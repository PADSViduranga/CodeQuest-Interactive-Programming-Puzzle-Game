import '../core/game_type.dart';
import '../domain/puzzle.dart';

abstract class PuzzleRepository {
  Future<List<Puzzle>> puzzlesForStage(String stageId);
}

/// Sample puzzles until puzzles are loaded from Firestore.
class SamplePuzzleRepository implements PuzzleRepository {
  @override
  Future<List<Puzzle>> puzzlesForStage(String stageId) async {
    Puzzle po(String id, String prompt, List<String> code, List<String> opts) {
      return Puzzle(
        id: id,
        type: GameType.predictOutput,
        language: 'python',
        level: 'beginner',
        title: 'Predict the output',
        prompt: prompt,
        payload: {
          'code': code,
          'options': [
            for (var i = 0; i < opts.length; i++)
              {'id': 'abcd'[i], 'text': opts[i]},
          ],
        },
        difficulty: 1,
        xpReward: 20,
        maxHints: 2,
      );
    }

    return [
      po(
        'demo_po_1',
        'What does this code print?',
        ['x = 3', 'for i in range(x):', '    x = x - 1', 'print(x)'],
        ['0', '1', '3', '2'],
      ),
      po(
        'demo_po_2',
        'What does this print?',
        ['nums = [4, 8, 15]', 'print(len(nums))'],
        ['2', '3', '4', '15'],
      ),
      po(
        'demo_po_3',
        'What does this print?',
        ['name = "Mito"', 'print(name.upper())'],
        ['Mito', 'MITO', 'mito', '"MITO"'],
      ),
    ];
  }
}
