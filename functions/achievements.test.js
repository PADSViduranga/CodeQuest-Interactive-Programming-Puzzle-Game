const test = require('node:test');
const assert = require('node:assert');
const {
  ACHIEVEMENTS,
  progress,
  newAchievements,
  bumpStat,
  maxStat,
} = require('./achievements');

const ids = (list) => list.map((a) => a.id);

test('achievement ids are unique and each is complete', () => {
  assert.strictEqual(new Set(ACHIEVEMENTS.map((a) => a.id)).size, ACHIEVEMENTS.length);
  for (const a of ACHIEVEMENTS) {
    assert.ok(a.name && a.description && a.stat, a.id);
    assert.ok(a.target > 0 && a.rewardXp > 0, a.id);
  }
});

test('progress counts up and stops at the target', () => {
  const a = ACHIEVEMENTS.find((x) => x.id === 'puzzle_10');
  assert.strictEqual(progress({}, a), 0);
  assert.strictEqual(progress({ stats: { puzzlesSolved: 4 } }, a), 4);
  assert.strictEqual(progress({ stats: { puzzlesSolved: 99 } }, a), 10);
});

test('a new player has nothing unlocked', () => {
  const r = newAchievements({});
  assert.deepStrictEqual(r.unlocked, []);
  assert.strictEqual(r.bonusXp, 0);
});

test('reaching a target unlocks it and pays its XP', () => {
  const r = newAchievements({ stats: { puzzlesSolved: 10 } });
  assert.deepStrictEqual(ids(r.unlocked), ['puzzle_10']);
  assert.strictEqual(r.bonusXp, 100);
});

test('an achievement is never unlocked twice', () => {
  const r = newAchievements({
    stats: { puzzlesSolved: 12 },
    achievements: ['puzzle_10'],
  });
  assert.deepStrictEqual(r.unlocked, []);
  assert.strictEqual(r.bonusXp, 0);
});

test('several unlocks at once add their XP together', () => {
  const r = newAchievements({
    stats: { puzzlesSolved: 50, miniGamesWon: 10, bestCombo: 5 },
  });
  assert.deepStrictEqual(ids(r.unlocked), ['puzzle_10', 'puzzle_50', 'minigames_10', 'combo_5']);
  assert.strictEqual(r.bonusXp, 100 + 300 + 100 + 100);
});

test('bad stats are treated as zero', () => {
  const r = newAchievements({ stats: { puzzlesSolved: 'ten', miniGamesWon: -3 } });
  assert.deepStrictEqual(r.unlocked, []);
  assert.deepStrictEqual(newAchievements({ stats: 'oops', achievements: 'x' }).unlocked, []);
});

test('bumpStat adds to a counter without changing the original', () => {
  const stats = { puzzlesSolved: 2 };
  assert.deepStrictEqual(bumpStat(stats, 'puzzlesSolved'), { puzzlesSolved: 3 });
  assert.deepStrictEqual(bumpStat(stats, 'miniGamesWon'), { puzzlesSolved: 2, miniGamesWon: 1 });
  assert.deepStrictEqual(stats, { puzzlesSolved: 2 });
  assert.deepStrictEqual(bumpStat(undefined, 'puzzlesSolved'), { puzzlesSolved: 1 });
});

test('maxStat keeps the higher value', () => {
  assert.deepStrictEqual(maxStat({ bestCombo: 4 }, 'bestCombo', 3), { bestCombo: 4 });
  assert.deepStrictEqual(maxStat({ bestCombo: 4 }, 'bestCombo', 6), { bestCombo: 6 });
  assert.deepStrictEqual(maxStat({}, 'bestCombo', 2), { bestCombo: 2 });
});
