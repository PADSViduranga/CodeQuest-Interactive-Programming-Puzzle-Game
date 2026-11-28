const test = require('node:test');
const assert = require('node:assert');
const { DAILY_BONUS_XP, dailyBonusStatus } = require('./daily');

const today = '2026-11-28';

test('the bonus is 150 XP', () => {
  assert.strictEqual(DAILY_BONUS_XP, 150);
});

test('a new player is locked', () => {
  assert.strictEqual(dailyBonusStatus({}, today), 'locked');
});

test('winning yesterday does not unlock today', () => {
  assert.strictEqual(dailyBonusStatus({ lastStreakDay: '2026-11-27' }, today), 'locked');
});

test('winning today makes the bonus ready', () => {
  assert.strictEqual(dailyBonusStatus({ lastStreakDay: today }, today), 'ready');
});

test('after claiming, it stays claimed for the rest of the day', () => {
  const user = { lastStreakDay: today, lastDailyBonusDay: today };
  assert.strictEqual(dailyBonusStatus(user, today), 'claimed');
});

test('a claim from yesterday does not block today', () => {
  const user = { lastStreakDay: today, lastDailyBonusDay: '2026-11-27' };
  assert.strictEqual(dailyBonusStatus(user, today), 'ready');
});
