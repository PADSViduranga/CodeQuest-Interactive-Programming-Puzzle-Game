import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/world_map/presentation/screens/world_map_screen.dart';
import 'features/lessons/presentation/screens/lesson_screen.dart';
import 'features/games/presentation/screens/practice_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';

class CodeQuestApp extends StatelessWidget {
  const CodeQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeQuest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const CodeQuestShell(),
    );
  }
}

class CodeQuestShell extends StatefulWidget {
  const CodeQuestShell({super.key});

  @override
  State<CodeQuestShell> createState() => _CodeQuestShellState();
}

class _CodeQuestShellState extends State<CodeQuestShell> {
  bool isLoading = true;
  bool onboarded = false;
  int tab = 0;
  String language = 'Python';
  String level = 'Beginner';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      onboarded = prefs.getBool('onboarding_complete') ?? false;
      language = prefs.getString('player_language') ?? 'Python';
      level = prefs.getString('player_level') ?? 'Beginner';
      isLoading = false;
    });
  }

  Future<void> _completeOnboarding(
    String selectedLanguage,
    String selectedLevel,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    await prefs.setString('player_language', selectedLanguage);
    await prefs.setString('player_level', selectedLevel);
    if (!mounted) return;
    setState(() {
      language = selectedLanguage;
      level = selectedLevel;
      onboarded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!onboarded) {
      return OnboardingScreen(onComplete: _completeOnboarding);
    }

    final pages = <Widget>[
      WorldMapScreen(
        language: language,
        level: level,
        onOpenLesson: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const LessonScreen()));
        },
      ),
      const PracticeScreen(),
      ProfileScreen(
        language: language,
        level: level,
        onProfileChanged: () => _loadProfile(),
      ),
    ];

    return Scaffold(
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.public), label: 'World'),
          NavigationDestination(icon: Icon(Icons.code), label: 'Practice'),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
