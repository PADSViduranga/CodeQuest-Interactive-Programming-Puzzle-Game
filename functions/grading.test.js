const test = require('node:test');
const assert = require('node:assert');
const { checkAnswer, comboXp, levelForXp } = require('./grading');

test('option games compare the selected option id', () => {
  const secret = { type: 'predict_output', answer: 'a' };
  assert.strictEqual(checkAnswer(secret, { selectedOptionId: 'a' }), true);
  assert.strictEqual(checkAnswer(secret, { selectedOptionId: 'b' }), false);
  assert.strictEqual(checkAnswer(secret, {}), false);
});

test('drag order needs the exact order', () => {
  const secret = { type: 'drag_order', answer: ['a', 'b', 'c'] };
  assert.strictEqual(checkAnswer(secret, { order: ['a', 'b', 'c'] }), true);
  assert.strictEqual(checkAnswer(secret, { order: ['b', 'a', 'c'] }), false);
  assert.strictEqual(checkAnswer(secret, { order: ['a', 'b'] }), false);
});

test('unknown game types are never correct', () => {
  assert.strictEqual(checkAnswer({ type: 'nope', answer: 'a' }, {}), false);
});

test('combo bonus grows and is capped', () => {
  assert.strictEqual(comboXp(20, 1), 20);
  assert.strictEqual(comboXp(20, 3), 30);
  assert.strictEqual(comboXp(20, 50), 45);
});

test('level rises every 100 XP', () => {
  assert.strictEqual(levelForXp(0), 1);
  assert.strictEqual(levelForXp(99), 1);
  assert.strictEqual(levelForXp(100), 2);
  assert.strictEqual(levelForXp(250), 3);
});

test('typing ignores extra spaces and accepts alternatives', () => {
  const secret = { type: 'typing', answer: ['len(nums)', 'len( nums )'] };
  assert.strictEqual(checkAnswer(secret, { text: '  len(nums)  ' }), true);
  assert.strictEqual(checkAnswer(secret, { text: 'LEN(nums)' }), false);
  assert.strictEqual(checkAnswer(secret, { text: 5 }), false);
});

test('grid needs exactly the right cells, in any order', () => {
  const secret = { type: 'grid', answer: ['x1', 'x3'] };
  assert.strictEqual(checkAnswer(secret, { selected: ['x3', 'x1'] }), true);
  assert.strictEqual(checkAnswer(secret, { selected: ['x1'] }), false);
  assert.strictEqual(checkAnswer(secret, { selected: ['x1', 'x3', 'x2'] }), false);
  assert.strictEqual(checkAnswer(secret, { selected: ['x1', 'x1'] }), false);
});
