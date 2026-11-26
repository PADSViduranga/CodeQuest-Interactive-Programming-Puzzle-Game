/** Pure grading rules. No Firebase here, so they are easy to test. */

function sameList(a, b) {
  return a.length === b.length && a.every((v, i) => v === b[i]);
}

/** secret = { type, answer }, answer = what the player sent. */
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

module.exports = { checkAnswer, comboXp, levelForXp };
