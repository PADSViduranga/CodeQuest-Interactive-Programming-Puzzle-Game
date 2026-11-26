// Fills the LOCAL emulator with the answers for the sample puzzles.
// Run only while the emulators are running: node seed.js
process.env.FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080';

const { initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');

initializeApp({ projectId: 'codequest-puzzle-game' });
const db = getFirestore();

const secrets = {
  demo_po_1: {
    type: 'predict_output',
    answer: 'a',
    explanation: 'range(3) runs the loop 3 times. x goes 2, 1, 0, so it prints 0.',
    hints: ['Count how many times the loop runs.', 'x drops by 1 every time.'],
  },
  demo_po_2: {
    type: 'predict_output',
    answer: 'b',
    explanation: 'len() counts the items in the list. There are 3 numbers.',
    hints: ['len() counts items.', 'Count the numbers in the brackets.'],
  },
  demo_po_3: {
    type: 'predict_output',
    answer: 'b',
    explanation: 'upper() turns every letter into a capital letter.',
    hints: ['upper() changes the case of the letters.', 'Think capital letters.'],
  },
  demo_do_1: {
    type: 'drag_order',
    answer: ['a', 'b', 'c', 'd'],
    explanation: 'Create total first, then loop and add each number, then print it.',
    hints: ['The variable must exist before the loop.', 'print comes last.'],
  },
  demo_fb_1: {
    type: 'fill_blank',
    answer: 'b',
    explanation: 'len() counts the items in the list, and the list has 3 numbers.',
    hints: ['Which function counts items?', 'sum adds, max and min pick one number.'],
  },
  demo_ty_1: {
    type: 'typing',
    answer: ['len(nums)'],
    explanation: 'len(nums) counts the items, and the list has 3 numbers.',
    hints: ['Which function counts items?', 'Put the list name in the brackets.'],
  },
  demo_gr_1: {
    type: 'grid',
    answer: ['c1', 'c3', 'c5'],
    explanation: 'Names cannot start with a digit, cannot be a keyword like class, and cannot contain a dash.',
    hints: ['One name starts with a number.', 'class is a reserved word.'],
  },
};

(async () => {
  for (const [id, data] of Object.entries(secrets)) {
    await db.collection('puzzleSecrets').doc(id).set({ xpReward: 20, ...data });
  }
  console.log(`Seeded ${Object.keys(secrets).length} puzzle secrets.`);
})();
