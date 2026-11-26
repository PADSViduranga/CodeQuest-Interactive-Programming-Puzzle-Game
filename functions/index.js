const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { checkAnswer, comboXp, levelForXp } = require('./grading');

initializeApp();
const db = getFirestore();

const ID = /^[A-Za-z0-9_-]{1,120}$/;

function requireUid(request) {
  const uid = request.auth && request.auth.uid;
  if (!uid) throw new HttpsError('unauthenticated', 'Sign in first.');
  return uid;
}

exports.ping = onCall(() => ({ ok: true }));

/**
 * Checks an answer on the server. The correct answers live in puzzleSecrets,
 * which no client can read. Repeating the same submissionId returns the first
 * result and awards nothing twice.
 */
exports.submitAnswer = onCall(async (request) => {
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

  return db.runTransaction(async (tx) => {
    const [sub, secretSnap, sessionSnap, userSnap] = await Promise.all([
      tx.get(subRef),
      tx.get(secretRef),
      tx.get(sessionRef),
      tx.get(userRef),
    ]);

    if (sub.exists) return sub.data().result; // already answered
    if (!secretSnap.exists) throw new HttpsError('not-found', 'Unknown puzzle.');

    const secret = secretSnap.data();
    const correct = checkAnswer(secret, answer);

    const prevCombo = sessionSnap.exists ? sessionSnap.data().combo || 0 : 0;
    const combo = correct ? prevCombo + 1 : 0;
    const xpAwarded = correct ? comboXp(secret.xpReward || 20, combo) : 0;

    const user = userSnap.exists ? userSnap.data() : {};
    const oldLevel = user.level || 1;
    const newTotalXp = (user.totalXp || 0) + xpAwarded;
    const newLevel = Math.max(oldLevel, levelForXp(newTotalXp));

    const result = {
      correct,
      xpAwarded,
      newTotalXp,
      newLevel,
      leveledUp: newLevel > oldLevel,
      comboCount: combo,
      explanation: secret.explanation || null,
    };

    tx.set(subRef, {
      puzzleId,
      result,
      createdAt: FieldValue.serverTimestamp(),
    });
    tx.set(
      sessionRef,
      { combo, updatedAt: FieldValue.serverTimestamp() },
      { merge: true },
    );
    if (xpAwarded > 0) {
      tx.set(userRef, { totalXp: newTotalXp, level: newLevel }, { merge: true });
    }
    return result;
  });
});

/** Returns hint number [hintNumber] (1 based) for a puzzle, or null. */
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
