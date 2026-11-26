enum GameMode {
  multipleChoice,
  typing,
  dragBuckets,
  hangman,
  codeLine,
  ordering,
  logicGate,
  sorting,
  stack,
}

class GamePair {
  final String item;
  final String category;
  const GamePair(this.item, this.category);
}

class GameDefinition {
  final String id;
  final String title;
  final String description;
  final GameMode mode;
  final String question;
  final String answer;
  final String explanation;
  final List<String> options;
  final List<GamePair> pairs;
  final String? hint;
  final List<String> codeLines;
  final List<String> sequence;
  final List<int> sortValues;
  final String category;
  final String difficulty;

  const GameDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.mode,
    required this.question,
    required this.answer,
    required this.explanation,
    this.options = const [],
    this.pairs = const [],
    this.hint,
    this.codeLines = const [],
    this.sequence = const [],
    this.sortValues = const [],
    this.category = 'Core',
    this.difficulty = 'Easy',
  });
}
