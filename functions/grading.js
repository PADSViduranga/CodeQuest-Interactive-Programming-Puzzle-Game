/** Pure grading rules. No Firebase here, so they are easy to test. */

function sameList(a, b) {
  return a.length === b.length && a.every((v, i) => v === b[i]);
}

/** secret = { type, answer }, answer = what the player sent. */
/** Same cells, in any order, no repeats. */
function sameSet(a, b) {
  return (
    a.length === b.length &&
    new Set(a).size === a.length &&
    a.every((v) => b.includes(v))
  );
}

/** Trimmed, with runs of spaces collapsed to one. */
function normalize(text) {
  return String(text).trim().replace(/\s+/g, ' ');
}

function checkAnswer(secret, answer) {
  if (!secret || !answer) return false;
  switch (secret.type) {
    case 'predict_output':
    case 'fill_blank':
      return (
        typeof answer.selectedOptionId === 'string' &&
        answer.selectedOptionId === secret.answer
      );
    case 'drag_order':
      return (
        Array.isArray(answer.order) &&
        Array.isArray(secret.answer) &&
        sameList(answer.order, secret.answer)
      );
    case 'grid':
      return (
        Array.isArray(answer.selected) &&
        Array.isArray(secret.answer) &&
        sameSet(answer.selected, secret.answer)
      );
    case 'typing': {
      if (typeof answer.text !== 'string') return false;
      const accepted = Array.isArray(secret.answer) ? secret.answer : [secret.answer];
      const given = normalize(answer.text);
      return accepted.some((a) => normalize(a) === given);
    }
    default:
      return false;
  }
}

/** Base XP plus a combo bonus: +5 per extra correct answer in a row, max +25. */
function comboXp(base, combo) {
  return base + Math.min(Math.max(combo - 1, 0), 5) * 5;
}

/** Level 1 at 0 XP, then one level for every 100 XP. */
function levelForXp(totalXp) {
  return Math.floor(totalXp / 100) + 1;
}

/** Types that are graded by running the player's code. */
function isCodeType(type) {
  return type === 'write_code' || type === 'fix_the_bug';
}

/**
 * Compares the output of each test run with what the test expects.
 * runs = [{ stdout, status }], tests = [{ expected }]. Status 3 means it ran without error.
 */
function gradeCodeRuns(tests, runs) {
  const total = tests.length;
  let passed = 0;
  for (let i = 0; i < total; i++) {
    const run = runs[i];
    if (!run || run.status !== 3) continue;
    const out = String(run.stdout || '').replace(/\r\n/g, '\n').trim();
    const want = String(tests[i].expected).replace(/\r\n/g, '\n').trim();
    if (out === want) passed++;
  }
  return { correct: total > 0 && passed === total, passed, total };
}

module.exports = { checkAnswer, gradeCodeRuns, isCodeType, comboXp, levelForXp };
