import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  static const _sections = [
    (
      'Using CodeQuest',
      'CodeQuest is a learning game. Use it to practise coding and have fun. Do not try to break the app or the servers.',
    ),
    (
      'Your account',
      'Keep your password private. You are responsible for what happens on your account. Guest play is limited to 10 minutes at a time.',
    ),
    (
      'Fair play',
      'Answers are checked on our servers. Cheating, cloning the answer list or using bots to climb the leaderboard can get an account removed.',
    ),
    (
      'Progress and points',
      'XP, levels and badges are kept on our servers. They have no money value and can change if a puzzle is fixed or removed.',
    ),
    (
      'Deleting your data',
      'You can delete your account and all your data at any time from Settings. This cannot be undone.',
    ),
    (
      'Changes',
      'We may update these terms as the app grows. Using the app after a change means you accept it.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of service'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final (title, body) in _sections)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(body, style: const TextStyle(height: 1.45)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
