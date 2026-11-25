import '../domain/answer_result.dart';
import 'answer_service.dart';

/// DEBUG ONLY. Checks the sample puzzles on the device so the game can be
/// played before the server exists. Real answers live on the server.
class DemoAnswerService implements AnswerService {
  static const _answers = {
    'demo_po_1': (
      'a',
      'range(3) runs the loop 3 times. x goes 2, 1, 0, so it prints 0.',
      ['Count how many times the loop runs.', 'x drops by 1 every time.'],
    ),
    'demo_po_2': (
      'b',
      'len() counts the items in the list. There are 3 numbers.',
      ['len() counts items.', 'Count the numbers in the brackets.'],
    ),
    'demo_po_3': (
      'b',
      'upper() turns every letter into a capital letter.',
      ['upper() changes the case of the letters.', 'Think capital letters.'],
    ),
  };

  final _combo = <String, int>{};
  var _totalXp = 0;

  @override
  Future<AnswerResult> submitAnswer({
    required String puzzleId,
    required String sessionId,
    required String submissionId,
    required Map<String, dynamic> answer,
    required int timeTakenMs,
    required int hintsUsed,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final entry = _answers[puzzleId];
    final correct = entry != null && answer['selectedOptionId'] == entry.$1;
    final combo = correct ? (_combo[sessionId] ?? 0) + 1 : 0;
    _combo[sessionId] = combo;
    final xp = correct ? 20 + (combo - 1) * 5 : 0;
    _totalXp += xp;
    return AnswerResult(
      correct: correct,
      xpAwarded: xp,
      newTotalXp: _totalXp,
      newLevel: 1,
      leveledUp: false,
      comboCount: combo,
      explanation: entry?.$2,
    );
  }

  @override
  Future<String?> getHint(String puzzleId, int hintNumber) async {
    final hints = _answers[puzzleId]?.$3;
    if (hints == null || hintNumber < 1 || hintNumber > hints.length) {
      return null;
    }
    return hints[hintNumber - 1];
  }
}
