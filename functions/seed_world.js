// Fills the LOCAL emulator with the world: stages and lessons.
// Run only while the emulators are running: node seed_world.js
const PROD = process.argv.includes('--prod');
if (!PROD) process.env.FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080';
console.log(PROD ? 'Writing to the REAL project codequest-puzzle-game' : 'Writing to the local emulator');

const { initializeApp } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');

initializeApp({ projectId: 'codequest-puzzle-game' });
const db = getFirestore();

const stages = [
  { id: 's1', title: 'Hello, World', subtitle: 'Print your first line', unlockXp: 0 },
  { id: 's2', title: 'Variables', subtitle: 'Store and name values', unlockXp: 40 },
  { id: 's3', title: 'Conditions', subtitle: 'Make decisions with if', unlockXp: 100 },
  { id: 's4', title: 'Loops', subtitle: 'Repeat code', unlockXp: 180 },
  { id: 's5', title: 'Functions', subtitle: 'Reuse your code', unlockXp: 280 },
  { id: 's6', title: 'Lists', subtitle: 'Work with collections', unlockXp: 400 },
  { id: 's7', title: 'Boss: The Basics', subtitle: 'Beat the first boss', unlockXp: 550, isBoss: true },
];

const lessons = {
  s1: {
    title: 'Hello, World',
    explanation: 'print() shows text on the screen. Text goes inside quotes. This is how every programmer starts.',
    example: ['print("Hello, World!")'],
    output: ['Hello, World!'],
    tip: 'Forget the quotes and Python thinks the words are names, not text.',
  },
  s2: {
    title: 'Variables',
    explanation: 'A variable is a named box that holds a value. Use = to put a value in the box.',
    example: ['name = "Mito"', 'xp = 40', 'print(name, xp)'],
    output: ['Mito 40'],
    tip: 'Pick clear names: lives_left is better than x.',
  },
  s3: {
    title: 'Conditions',
    explanation: 'if runs code only when something is true. else runs when it is not.',
    example: ['xp = 120', 'if xp >= 100:', '    print("Level up!")', 'else:', '    print("Keep going!")'],
    output: ['Level up!'],
    tip: 'Indent the code under if with 4 spaces. Python uses spaces to group code.',
  },
  s4: {
    title: 'Loops',
    explanation: 'A loop repeats code. for i in range(3) runs three times, counting 0, 1, 2.',
    example: ['for i in range(3):', '    print("Go!", i)'],
    output: ['Go! 0', 'Go! 1', 'Go! 2'],
    tip: 'range(3) stops before 3. It counts from 0.',
  },
  s5: {
    title: 'Functions',
    explanation: 'A function is a named block of code you can reuse. def creates one and return sends a value back.',
    example: ['def double(n):', '    return n * 2', '', 'print(double(4))'],
    output: ['8'],
    tip: 'Define a function once, then call it as many times as you like.',
  },
  s6: {
    title: 'Lists',
    explanation: 'A list holds many values in order. Count from 0 to reach an item.',
    example: ['nums = [4, 8, 15]', 'print(nums[0])', 'print(len(nums))'],
    output: ['4', '3'],
    tip: 'The first item is nums[0], not nums[1].',
  },
};

(async () => {
  for (const [i, s] of stages.entries()) {
    const { id, ...data } = s;
    await db.collection('stages').doc(id).set({ isBoss: false, ...data, order: i });
  }
  for (const [id, data] of Object.entries(lessons)) {
    await db.collection('lessons').doc(id).set(data);
  }
  console.log(`Seeded ${stages.length} stages and ${Object.keys(lessons).length} lessons.`);
})();
