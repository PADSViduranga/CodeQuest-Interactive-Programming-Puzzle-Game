const test = require('node:test');
const assert = require('node:assert');
const { dayKey, daysBetween, nextStreak } = require('./streak');

test('dayKey uses the UTC date', () => {
  assert.strictEqual(dayKey(new Date('2026-11-28T23:59:59Z')), '2026-11-28');
  assert.strictEqual(dayKey(new Date('2026-11-29T00:00:00Z')), '2026-11-29');
});

test('daysBetween counts across months and years', () => {
  assert.strictEqual(daysBetween('2026-11-28', '2026-11-29'), 1);
  assert.strictEqual(daysBetween('2026-11-30', '2026-12-01'), 1);
  assert.strictEqual(daysBetween('2026-12-31', '2027-01-01'), 1);
  assert.strictEqual(daysBetween('2026-11-28', '2026-11-28'), 0);
  assert.strictEqual(daysBetween('2026-11-28', '2026-12-05'), 7);
});

test('the first win starts a streak of 1', () => {
  const r = nextStreak({}, '2026-11-28');
  assert.strictEqual(r.currentStreak, 1);
  assert.strictEqual(r.longestStreak, 1);
  assert.strictEqual(r.lastStreakDay, '2026-11-28');
  assert.strictEqual(r.increased, true);
});

test('a second win on the same day changes nothing', () => {
  const user = { currentStreak: 3, longestStreak: 5, lastStreakDay: '2026-11-28' };
  const r = nextStreak(user, '2026-11-28');
  assert.strictEqual(r.currentStreak, 3);
  assert.strictEqual(r.longestStreak, 5);
  assert.strictEqual(r.increased, false);
});

test('a win on the next day grows the streak', () => {
  const user = { currentStreak: 3, longestStreak: 3, lastStreakDay: '2026-11-28' };
  const r = nextStreak(user, '2026-11-29');
  assert.strictEqual(r.currentStreak, 4);
  assert.strictEqual(r.longestStreak, 4);
  assert.strictEqual(r.lastStreakDay, '2026-11-29');
  assert.strictEqual(r.increased, true);
});

test('growing across a year boundary works', () => {
  const user = { currentStreak: 9, longestStreak: 9, lastStreakDay: '2026-12-31' };
  assert.strictEqual(nextStreak(user, '2027-01-01').currentStreak, 10);
});

test('missing a day restarts the streak but keeps the best one', () => {
  const user = { currentStreak: 6, longestStreak: 6, lastStreakDay: '2026-11-26' };
  const r = nextStreak(user, '2026-11-28');
  assert.strictEqual(r.currentStreak, 1);
  assert.strictEqual(r.longestStreak, 6);
  assert.strictEqual(r.lastStreakDay, '2026-11-28');
});

test('a clock that goes backwards never lowers the streak', () => {
  const user = { currentStreak: 4, longestStreak: 4, lastStreakDay: '2026-11-28' };
  const r = nextStreak(user, '2026-11-27');
  assert.strictEqual(r.currentStreak, 4);
  assert.strictEqual(r.lastStreakDay, '2026-11-28');
});

test('an old profile with a streak but no last day restarts safely', () => {
  const r = nextStreak({ currentStreak: 2, longestStreak: 2 }, '2026-11-28');
  assert.strictEqual(r.currentStreak, 1);
  assert.strictEqual(r.longestStreak, 2);
});

const { addRecentDay } = require('./streak');

test('a win adds today to the recent days', () => {
  assert.deepStrictEqual(nextStreak({}, '2026-11-28').recentDays, ['2026-11-28']);
  const user = { currentStreak: 1, lastStreakDay: '2026-11-27', recentDays: ['2026-11-27'] };
  assert.deepStrictEqual(nextStreak(user, '2026-11-28').recentDays, ['2026-11-27', '2026-11-28']);
});

test('the same day is never listed twice', () => {
  assert.deepStrictEqual(addRecentDay(['2026-11-28'], '2026-11-28'), ['2026-11-28']);
});

test('only the newest 14 days are kept, oldest first', () => {
  const days = [];
  for (let i = 1; i <= 14; i++) days.push('2026-11-' + String(i).padStart(2, '0'));
  const out = addRecentDay(days, '2026-11-15');
  assert.strictEqual(out.length, 14);
  assert.strictEqual(out[0], '2026-11-02');
  assert.strictEqual(out[13], '2026-11-15');
});

test('bad entries in recent days are ignored', () => {
  assert.deepStrictEqual(addRecentDay([3, null, '2026-11-27'], '2026-11-28'), ['2026-11-27', '2026-11-28']);
  assert.deepStrictEqual(addRecentDay('oops', '2026-11-28'), ['2026-11-28']);
});
