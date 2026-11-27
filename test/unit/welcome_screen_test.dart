import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codequest/features/auth/presentation/screens/welcome_screen.dart';

void main() {
  testWidgets('welcome screen shows the name and both buttons', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    expect(find.text('CodeQuest'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
  });
}
