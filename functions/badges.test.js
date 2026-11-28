const test = require('node:test');
const assert = require('node:assert');
const { BADGES, newBadges } = require('./badges');

const ids = (list) => list.map((b) => b.id);

test('badge ids are unique and each has a name and description', () => {
  assert.strictEqual(new Set(BADGES.map((b) => b.id)).size, BADGES.length);
  for (const b of BADGES) {
    assert.ok(b.name && b.description, b.id);
  }
});

test('the first win earns First Win and nothing else', () => {
  const got = newBadges({ totalXp: 20, level: 1, currentStreak: 1, badges: [] });
  assert.deepStrictEqual(ids(got), ['first_win']);
});

test('badges already owned are never awarded twice', () => {
  const got = newBadges({ totalXp: 20, level: 1, currentStreak: 1, badges: ['first_win'] });
  assert.deepStrictEqual(got, []);
});

test('a missing badges field is treated as none', () => {
  assert.deepStrictEqual(ids(newBadges({ totalXp: 20, level: 1, currentStreak: 1 })), ['first_win']);
});

test('streak badges unlock at 3 and 7 days', () => {
  const base = { totalXp: 20, level: 1, badges: ['first_win'] };
  assert.deepStrictEqual(ids(newBadges({ ...base, currentStreak: 2 })), []);
  assert.deepStrictEqual(ids(newBadges({ ...base, currentStreak: 3 })), ['streak_3']);
  assert.deepStrictEqual(
    ids(newBadges({ ...base, currentStreak: 7, badges: ['first_win', 'streak_3'] })),
    ['streak_7'],
  );
});

test('level 5 and 500 XP badges unlock at their thresholds', () => {
  const base = { currentStreak: 1, badges: ['first_win'] };
  assert.deepStrictEqual(ids(newBadges({ ...base, level: 4, totalXp: 499 })), []);
  assert.deepStrictEqual(ids(newBadges({ ...base, level: 5, totalXp: 499 })), ['level_5']);
  assert.deepStrictEqual(ids(newBadges({ ...base, level: 4, totalXp: 500 })), ['xp_500']);
});

test('several badges can unlock in one win', () => {
  const got = newBadges({ totalXp: 520, level: 6, currentStreak: 7, badges: [] });
  assert.deepStrictEqual(ids(got), ['first_win', 'streak_3', 'streak_7', 'level_5', 'xp_500']);
});

test('results only carry id, name and description', () => {
  const [b] = newBadges({ totalXp: 20, level: 1, currentStreak: 1 });
  assert.deepStrictEqual(Object.keys(b).sort(), ['description', 'id', 'name']);
});

test('unknown badge ids on a profile are ignored', () => {
  const got = newBadges({ totalXp: 20, level: 1, currentStreak: 1, badges: ['something_old'] });
  assert.deepStrictEqual(ids(got), ['first_win']);
});
