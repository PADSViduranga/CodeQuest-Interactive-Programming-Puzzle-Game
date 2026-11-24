import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codequest/app.dart';

void main() {
  testWidgets('app shows the CodeQuest title', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CodeQuestApp()));
    expect(find.text('CodeQuest'), findsOneWidget);
  });
}
