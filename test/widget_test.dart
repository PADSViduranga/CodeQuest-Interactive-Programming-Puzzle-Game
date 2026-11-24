import 'package:codequest/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App starts with onboarding', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const CodeQuestApp());
    await tester.pumpAndSettle();
    expect(find.text('CODEQUEST'), findsOneWidget);
    expect(find.text('Learn by playing'), findsOneWidget);
  });

  testWidgets('Onboarding saves selections and opens the world map', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const CodeQuestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Choose your toolkit'), findsOneWidget);

    await tester.tap(find.text('Start my journey'));
    await tester.pumpAndSettle();

    expect(find.text('Your learning world'), findsOneWidget);
    expect(find.text('Python Valley'), findsOneWidget);
  });
}
