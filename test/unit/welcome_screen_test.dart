import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codequest/features/auth/presentation/screens/welcome_screen.dart';

void main() {
  testWidgets('welcome screen shows the name and both buttons', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: WelcomeScreen())),
    );

    expect(find.text('CodeQuest'), findsOneWidget);
    expect(find.text('GET STARTED'), findsOneWidget);
    expect(find.text('I ALREADY HAVE AN ACCOUNT'), findsOneWidget);
  });
}
