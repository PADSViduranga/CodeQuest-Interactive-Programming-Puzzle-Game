import 'package:codequest/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App shows the CodeQuest title', (tester) async {
    await tester.pumpWidget(const CodeQuestApp());
    expect(find.text('CodeQuest'), findsOneWidget);
  });
}
