class Lesson {
  const Lesson({
    required this.title,
    required this.explanation,
    required this.example,
    required this.output,
    required this.tip,
  });

  final String title;
  final String explanation;
  final List<String> example;
  final List<String> output;
  final String tip;

  factory Lesson.fromMap(Map<String, dynamic> m) => Lesson(
    title: (m['title'] as String?) ?? '',
    explanation: (m['explanation'] as String?) ?? '',
    example: (m['example'] as List?)?.cast<String>() ?? const [],
    output: (m['output'] as List?)?.cast<String>() ?? const [],
    tip: (m['tip'] as String?) ?? '',
  );
}

/// Sample Python lessons until lessons are loaded from Firestore.
const sampleLessons = <String, Lesson>{
  's1': Lesson(
    title: 'Hello, World',
    explanation: 'print() shows text on the screen. Text goes inside quotes. This is how every programmer starts.',
    example: ['print("Hello, World!")'],
    output: ['Hello, World!'],
    tip: 'Forget the quotes and Python thinks the words are names, not text.',
  ),
  's2': Lesson(
    title: 'Variables',
    explanation: 'A variable is a named box that holds a value. Use = to put a value in the box.',
    example: ['name = "Mito"', 'xp = 40', 'print(name, xp)'],
    output: ['Mito 40'],
    tip: 'Pick clear names: lives_left is better than x.',
  ),
  's3': Lesson(
    title: 'Conditions',
    explanation:
        'if runs code only when something is true. else runs when it is not.',
    example: [
      'xp = 120',
      'if xp >= 100:',
      '    print("Level up!")',
      'else:',
      '    print("Keep going")',
    ],
    output: ['Level up!'],
    tip: 'The indented lines belong to the if. Indentation matters in Python.',
  ),
  's4': Lesson(
    title: 'Loops',
    explanation: 'A for loop repeats code once for every item in a sequence. Use it when you know how many times to repeat.',
    example: ['for i in range(3):', '    print("Hi", i)'],
    output: ['Hi 0', 'Hi 1', 'Hi 2'],
    tip: 'range(3) counts 0, 1, 2. It stops before 3.',
  ),
  's5': Lesson(
    title: 'Functions',
    explanation: 'A function is a reusable block of code. Define it once with def, then call it whenever you need it.',
    example: [
      'def greet(name):',
      '    return "Hi " + name',
      '',
      'print(greet("Sam"))',
    ],
    output: ['Hi Sam'],
    tip: 'return sends a value back to whoever called the function.',
  ),
  's6': Lesson(
    title: 'Lists',
    explanation: 'A list holds many values in order. Use square brackets, and count positions from 0.',
    example: [
      'scores = [10, 20, 30]',
      'scores.append(40)',
      'print(scores[0], len(scores))',
    ],
    output: ['10 4'],
    tip: 'The first item is scores[0], not scores[1].',
  ),
  's7': Lesson(
    title: 'Boss: The Basics',
    explanation: 'The boss mixes everything: variables, conditions, loops, functions and lists. Read this once, then beat it.',
    example: [
      'def total(nums):',
      '    s = 0',
      '    for n in nums:',
      '        s += n',
      '    return s',
      '',
      'print(total([1, 2, 3]))',
    ],
    output: ['6'],
    tip: 'Break a hard puzzle into small steps and test each one.',
  ),
};
