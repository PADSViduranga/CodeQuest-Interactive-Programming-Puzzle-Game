import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

class CodeQuestApp extends StatelessWidget {
  const CodeQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeQuest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const Scaffold(body: Center(child: Text('CodeQuest'))),
    );
  }
}
