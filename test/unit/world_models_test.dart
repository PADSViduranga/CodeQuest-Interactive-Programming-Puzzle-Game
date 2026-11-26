import 'package:codequest/features/lessons/domain/lesson.dart';
import 'package:codequest/features/world_map/domain/stage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Stage.fromMap reads every field', () {
    final s = Stage.fromMap('s9', {
      'title': 'Loops',
      'subtitle': 'Repeat code',
      'unlockXp': 180,
      'isBoss': true,
    });
    expect(s.id, 's9');
    expect(s.title, 'Loops');
    expect(s.unlockXp, 180);
    expect(s.isBoss, true);
  });

  test('Stage.fromMap has safe defaults', () {
    final s = Stage.fromMap('s1', {});
    expect(s.unlockXp, 0);
    expect(s.isBoss, false);
  });

  test('Lesson.fromMap reads the code lines', () {
    final l = Lesson.fromMap({
      'title': 'Hello',
      'explanation': 'e',
      'example': ['print("hi")'],
      'output': ['hi'],
      'tip': 't',
    });
    expect(l.example, ['print("hi")']);
    expect(l.output, ['hi']);
  });
}
