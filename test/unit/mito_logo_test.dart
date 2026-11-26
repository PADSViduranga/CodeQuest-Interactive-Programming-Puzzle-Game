import 'package:codequest/core/widgets/mito_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MitoLogo draws at the size it is given', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: MitoLogo(size: 80))),
      ),
    );
    expect(tester.getSize(find.byType(MitoLogo)), const Size(80, 80));
  });
}
