import '../domain/answer_result.dart';
import 'answer_service.dart';

class _Demo {
  const _Demo(this.answer, this.explanation, this.hints);

  /// A String (option id) or a List of ids (correct order).
  final Object answer;
  final String explanation;
  final List<String> hints;
}

/// DEBUG ONLY. Checks the sample puzzles on the device so the game can be
/// played before the server exists. Real answers live on the server.
class DemoAnswerService implements AnswerService {
  static const _demo = {
    'demo_po_1': _Demo(
      'a',
      'range(3) runs the loop 3 times. x goes 2, 1, 0, so it prints 0.',
      ['Count how many times the loop runs.', 'x drops by 1 every time.'],
    ),
    'demo_po_2': _Demo(
      'b',
      'len() counts the items in the list. There are 3 numbers.',
      ['len() counts items.', 'Count the numbers in the brackets.'],
    ),
    'demo_po_3': _Demo(
      'b',
      'upper() turns every letter into a capital letter.',
      ['upper() changes the case of the letters.', 'Think capital letters.'],
    ),
    'demo_do_1': _Demo(
      ['a', 'b', 'c', 'd'],
      'Create total first, then loop and add each number, then print it.',
      ['The variable must exist before the loop.', 'print comes last.'],
    ),
  };

  final _combo = <String, int>{};
  var _totalXp = 0;

  bool _isCorrect(_Demo? entry, Map<String, dynamic> answer) {
    if (entry == null) return false;
    final expected = entry.answer;
    if (expected is String) return answer['selectedOptionId'] == expected;
    final given = answer['order'];
    if (expected is List && given is List && given.length == expected.length) {
      for (var i = 0; i < expected.length; i++) {
        if (expected[i] != given[i]) return false;
      }
      return true;
    }
    return false;
  }

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
    final entry = _demo[puzzleId];
    final correct = _isCorrect(entry, answer);
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
      explanation: entry?.explanation,
    );
  }

  @override
  Future<String?> getHint(String puzzleId, int hintNumber) async {
    final hints = _demo[puzzleId]?.hints;
    if (hints == null || hintNumber < 1 || hintNumber > hints.length) {
      return null;
    }
    return hints[hintNumber - 1];
  }
}
