const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { checkAnswer, gradeCodeRuns, isCodeType, comboXp, levelForXp } = require('./grading');
const { dayKey, nextStreak } = require('./streak');
const { newBadges } = require('./badges');
const { DAILY_BONUS_XP, dailyBonusStatus } = require('./daily');
const { runPython } = require('./judge0');

initializeApp();
const db = getFirestore();

const ID = /^[A-Za-z0-9_-]{1,120}$/;
const MAX_CODE_LENGTH = 5000;

function requireUid(request) {
  const uid = request.auth && request.auth.uid;
  if (!uid) throw new HttpsError('unauthenticated', 'Sign in first.');
  return uid;
}

exports.ping = onCall(() => ({ ok: true }));

/** Runs the player's code against the hidden tests. Returns { correct, passed, total, firstError }. */
async function gradeCode(secret, code) {
  const tests = Array.isArray(secret.tests) ? secret.tests : [];
  if (!tests.length) throw new HttpsError('failed-precondition', 'Puzzle has no tests.');
  const runs = [];
  for (const t of tests) {
    try {
      runs.push(await runPython(code, t.stdin));
    } catch (e) {
      console.error('Judge0 failed', e);
      throw new HttpsError('unavailable', 'The code runner is busy. Try again.');
    }
  }
  const graded = gradeCodeRuns(tests, runs);
  const bad = runs.find((r) => r.status !== 3);
  const firstError = bad ? (bad.stderr || bad.compileOutput || '').trim().split('\n').slice(-3).join('\n') : null;
  return { ...graded, firstError };
}

/**
 * Checks an answer on the server. The correct answers live in puzzleSecrets,
 * which no client can read. Repeating the same submissionId returns the first
 * result and awards nothing twice.
 */
exports.submitAnswer = onCall({ timeoutSeconds: 60 }, async (request) => {
  const uid = requireUid(request);
  const { puzzleId, sessionId, submissionId, answer } = request.data || {};
  if (
    !ID.test(puzzleId || '') ||
    !ID.test(sessionId || '') ||
    !ID.test(submissionId || '') ||
    typeof answer !== 'object' ||
    answer === null
  ) {
    throw new HttpsError('invalid-argument', 'Bad answer request.');
  }

  const userRef = db.collection('users').doc(uid);
  const subRef = userRef.collection('submissions').doc(submissionId);
  const sessionRef = userRef.collection('sessions').doc(sessionId);
  const secretRef = db.collection('puzzleSecrets').doc(puzzleId);

  // Already answered? Return the first result without doing any work.
  const existing = await subRef.get();
  if (existing.exists) return existing.data().result;

  const secretSnap = await secretRef.get();
  if (!secretSnap.exists) throw new HttpsError('not-found', 'Unknown puzzle.');
  const secret = secretSnap.data();

  // Grade outside the transaction: running code is slow and must not hold it open.
  let correct;
  let codeInfo = null;
  if (isCodeType(secret.type)) {
    if (typeof answer.code !== 'string' || !answer.code.trim() || answer.code.length > MAX_CODE_LENGTH) {
      throw new HttpsError('invalid-argument', 'Send your code (up to 5000 characters).');
    }
    codeInfo = await gradeCode(secret, answer.code);
    correct = codeInfo.correct;
  } else {
    correct = checkAnswer(secret, answer);
  }

  return db.runTransaction(async (tx) => {
    const [sub, sessionSnap, userSnap] = await Promise.all([
      tx.get(subRef),
      tx.get(sessionRef),
      tx.get(userRef),
    ]);
    if (sub.exists) return sub.data().result; // a parallel request won

    const prevCombo = sessionSnap.exists ? sessionSnap.data().combo || 0 : 0;
    const combo = correct ? prevCombo + 1 : 0;
    const xpAwarded = correct ? comboXp(secret.xpReward || 20, combo) : 0;

    const user = userSnap.exists ? userSnap.data() : {};
    const oldLevel = user.level || 1;
    const newTotalXp = (user.totalXp || 0) + xpAwarded;
    const newLevel = Math.max(oldLevel, levelForXp(newTotalXp));
    const streak = xpAwarded > 0 ? nextStreak(user, dayKey(new Date())) : null;
    const earned = streak
      ? newBadges({
          ...user,
          totalXp: newTotalXp,
          level: newLevel,
          currentStreak: streak.currentStreak,
        })
      : [];

    let explanation = secret.explanation || null;
    if (codeInfo) {
      const line = `Passed ${codeInfo.passed} of ${codeInfo.total} tests.`;
      const err = !correct && codeInfo.firstError ? `\n${codeInfo.firstError}` : '';
      explanation = correct ? [line, secret.explanation].filter(Boolean).join(' ') : line + err;
    }

    const result = {
      correct,
      xpAwarded,
      newTotalXp,
      newLevel,
      leveledUp: newLevel > oldLevel,
      comboCount: combo,
      currentStreak: streak ? streak.currentStreak : user.currentStreak || 0,
      newBadges: earned,
      explanation,
    };

    tx.set(subRef, { puzzleId, result, createdAt: FieldValue.serverTimestamp() });
    tx.set(sessionRef, { combo, updatedAt: FieldValue.serverTimestamp() }, { merge: true });
    if (xpAwarded > 0) {
      tx.set(
        userRef,
        {
          totalXp: newTotalXp,
          level: newLevel,
          badges: [...(user.badges || []), ...earned.map((b) => b.id)],
          currentStreak: streak.currentStreak,
          longestStreak: streak.longestStreak,
          lastStreakDay: streak.lastStreakDay,
          recentDays: streak.recentDays,
        },
        { merge: true },
      );
    }
    return result;
  });
});

/** Returns hint number [hintNumber] (1 based) for a puzzle, or null. */
const MINI_GAME_XP = 50;

// Mini-games are graded in the app, so the server cannot verify a win.
// It bounds the reward instead: a flat amount, once per game per day.
exports.awardMiniGameXp = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Sign in first.');
  const gameId = request.data && request.data.gameId;
  if (typeof gameId !== 'string' || !/^[a-z0-9_]{1,40}$/.test(gameId)) {
    throw new HttpsError('invalid-argument', 'Bad game id.');
  }
  const db = getFirestore();
  const uid = request.auth.uid;
  const userRef = db.doc(`users/${uid}`);
  const day = new Date().toISOString().slice(0, 10);
  const playRef = db.doc(`users/${uid}/miniGames/${gameId}_${day}`);

  try {
  return await db.runTransaction(async (tx) => {
    const [userSnap, playSnap] = await Promise.all([tx.get(userRef), tx.get(playRef)]);
    const user = userSnap.exists ? userSnap.data() : {};
    const oldXp = user.totalXp || 0;
    const oldLevel = user.level || 1;
    if (playSnap.exists) return { xpAwarded: 0, totalXp: oldXp, level: oldLevel };
    const totalXp = oldXp + MINI_GAME_XP;
    const level = Math.max(oldLevel, levelForXp(totalXp));
    tx.set(playRef, { gameId, xpAwarded: MINI_GAME_XP, createdAt: FieldValue.serverTimestamp() });
    const streak = nextStreak(user, dayKey(new Date()));
    const earned = newBadges({
      ...user,
      totalXp,
      level,
      currentStreak: streak.currentStreak,
    });
    tx.set(
      userRef,
      {
        totalXp,
        level,
        badges: [...(user.badges || []), ...earned.map((b) => b.id)],
        currentStreak: streak.currentStreak,
        longestStreak: streak.longestStreak,
        lastStreakDay: streak.lastStreakDay,
        recentDays: streak.recentDays,
      },
      { merge: true },
    );
    return {
      xpAwarded: MINI_GAME_XP,
      totalXp,
      level,
      currentStreak: streak.currentStreak,
      newBadges: earned,
    };
  });
  } catch (e) {
    if (e instanceof HttpsError) throw e;
    console.error('awardMiniGameXp failed', e);
    throw new HttpsError('internal', String((e && e.message) || e).slice(0, 100));
  }
});

exports.getHint = onCall(async (request) => {
  requireUid(request);
  const { puzzleId, hintNumber } = request.data || {};
  if (!ID.test(puzzleId || '') || !Number.isInteger(hintNumber)) {
    throw new HttpsError('invalid-argument', 'Bad hint request.');
  }
  const snap = await db.collection('puzzleSecrets').doc(puzzleId).get();
  if (!snap.exists) throw new HttpsError('not-found', 'Unknown puzzle.');
  const hints = snap.data().hints || [];
  return { hint: hints[hintNumber - 1] || null };
});

/**
 * Pays the daily bonus once a day, after the player has won something today.
 * Returns { status, xpAwarded, totalXp, level, newBadges }.
 */
exports.claimDailyBonus = onCall(async (request) => {
  const uid = requireUid(request);
  const userRef = db.doc(`users/${uid}`);
  const today = dayKey(new Date());

  try {
    return await db.runTransaction(async (tx) => {
      const userSnap = await tx.get(userRef);
      const user = userSnap.exists ? userSnap.data() : {};
      const oldXp = user.totalXp || 0;
      const oldLevel = user.level || 1;
      const status = dailyBonusStatus(user, today);
      if (status !== 'ready') {
        return { status, xpAwarded: 0, totalXp: oldXp, level: oldLevel, newBadges: [] };
      }
      const totalXp = oldXp + DAILY_BONUS_XP;
      const level = Math.max(oldLevel, levelForXp(totalXp));
      const earned = newBadges({ ...user, totalXp, level });
      tx.set(
        userRef,
        {
          totalXp,
          level,
          badges: [...(user.badges || []), ...earned.map((b) => b.id)],
          lastDailyBonusDay: today,
        },
        { merge: true },
      );
      return { status: 'claimed', xpAwarded: DAILY_BONUS_XP, totalXp, level, newBadges: earned };
    });
  } catch (e) {
    if (e instanceof HttpsError) throw e;
    console.error('claimDailyBonus failed', e);
    throw new HttpsError('internal', String((e && e.message) || e).slice(0, 100));
  }
});
