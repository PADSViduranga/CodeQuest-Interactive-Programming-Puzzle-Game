import 'package:codequest/features/profile/presentation/widgets/avatar_circle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unknown avatar ids fall back to the first one', () {
    expect(avatarFor('nope').id, 'mito_1');
    expect(avatarFor('mito_3').id, 'mito_3');
  });

  test('there are six avatars with unique ids', () {
    expect(avatarOptions.map((a) => a.id).toSet().length, 6);
  });
}
