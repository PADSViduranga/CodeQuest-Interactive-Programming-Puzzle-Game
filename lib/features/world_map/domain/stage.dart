enum StageState { done, current, locked }

class Stage {
  const Stage({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.unlockXp,
    this.isBoss = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final int unlockXp;
  final bool isBoss;
}

/// Sample stages until worlds are loaded from Firestore.
const sampleWorldTitle = 'World 1 · The Basics';

const sampleStages = [
  Stage(
    id: 's1',
    title: 'Hello, World',
    subtitle: 'Print your first line',
    unlockXp: 0,
  ),
  Stage(
    id: 's2',
    title: 'Variables',
    subtitle: 'Store and name values',
    unlockXp: 40,
  ),
  Stage(
    id: 's3',
    title: 'Conditions',
    subtitle: 'Make decisions with if',
    unlockXp: 100,
  ),
  Stage(id: 's4', title: 'Loops', subtitle: 'Repeat code', unlockXp: 180),
  Stage(
    id: 's5',
    title: 'Functions',
    subtitle: 'Reuse your code',
    unlockXp: 280,
  ),
  Stage(
    id: 's6',
    title: 'Lists',
    subtitle: 'Work with collections',
    unlockXp: 400,
  ),
  Stage(
    id: 's7',
    title: 'Boss: The Basics',
    subtitle: 'Beat the first boss',
    unlockXp: 550,
    isBoss: true,
  ),
];

StageState stageStateFor(int xp, List<Stage> stages, int index) {
  final stage = stages[index];
  if (xp < stage.unlockXp) return StageState.locked;
  final isLast = index == stages.length - 1;
  if (!isLast && xp >= stages[index + 1].unlockXp) return StageState.done;
  return StageState.current;
}
