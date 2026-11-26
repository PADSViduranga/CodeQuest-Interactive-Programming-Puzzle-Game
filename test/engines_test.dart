import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:member4_minigames/engines/multiple_choice_engine.dart';
import 'package:member4_minigames/engines/typing_engine.dart';
import 'package:member4_minigames/engines/drag_buckets_engine.dart';
import 'package:member4_minigames/models/game_definition.dart';

void main() {
  testWidgets('Multiple choice engine displays its question and options',
      (tester) async {
    bool? answer;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MultipleChoiceEngine(
          question: '2 + 2 = ?',
          options: const ['3', '4'],
          correctAnswer: '4',
          onAnswered: (value) => answer = value,
        ),
      ),
    ));
    expect(find.text('2 + 2 = ?'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    await tester.tap(find.text('4'));
    await tester.pump();
    await tester.tap(find.text('Submit answer'));
    await tester.pump();
    expect(answer, true);
  });

  testWidgets('Typing engine accepts the correct answer', (tester) async {
    bool? answer;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TypingEngine(
          question: 'Type hello',
          correctAnswer: 'hello',
          onAnswered: (value) => answer = value,
        ),
      ),
    ));
    await tester.enterText(find.byType(TextField), 'hello');
    await tester.tap(find.text('Check answer'));
    expect(answer, true);
  });

  testWidgets('Drag buckets engine displays category buckets', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DragBucketsEngine(
          pairs: const [GamePair('200 OK', 'Success')],
          onCompleted: (_) {},
        ),
      ),
    ));
    expect(find.text('Success'), findsOneWidget);
    expect(find.text('200 OK'), findsOneWidget);
  });
}
