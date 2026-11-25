import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/daily_challenge/presentation/screens/daily_challenge_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/main_shell.dart';
import '../../features/leaderboard/presentation/screens/leaderboard_screen.dart';
import '../../features/lessons/presentation/screens/lesson_screen.dart';
import '../../features/onboarding/presentation/screens/choose_language_screen.dart';
import '../../features/onboarding/presentation/screens/choose_level_screen.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/rewards/presentation/screens/badge_unlocked_screen.dart';
import '../../features/rewards/presentation/screens/level_up_screen.dart';
import '../../features/rewards/presentation/screens/stage_complete_screen.dart';
import '../../features/settings/presentation/screens/delete_account_screen.dart';
import '../../features/settings/presentation/screens/privacy_policy_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import 'app_routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(authStateProvider, (_, _) => refresh.value++);
  ref.listen(playerProfileProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  const authPages = {
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.resetPassword,
  };
  const setupPages = {AppRoutes.chooseLanguage, AppRoutes.chooseLevel};

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      if (auth.isLoading) return null;

      final user = auth.value;
      final location = state.matchedLocation;
      final onAuthPage = authPages.contains(location);

      // Logged out: only the auth pages are allowed.
      if (user == null) return onAuthPage ? null : AppRoutes.login;

      // A guest may open Register to upgrade their account.
      final guestRegistering = user.isGuest && location == AppRoutes.register;
      if (onAuthPage && !guestRegistering) return AppRoutes.home;

      // Wait for the profile, then make sure language and level are chosen.
      final profileState = ref.read(playerProfileProvider);
      if (profileState.isLoading) return null;
      final profile = profileState.value;
      if (profile == null) return null;

      final needsSetup =
          profile.selectedLanguage == null || profile.selectedLevel == null;
      final onSetupPage = setupPages.contains(location);
      if (needsSetup && !onSetupPage && !guestRegistering) {
        return AppRoutes.chooseLanguage;
      }
      if (!needsSetup && onSetupPage) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (_, _) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.chooseLanguage,
        builder: (_, _) => const ChooseLanguageScreen(),
      ),
      GoRoute(
        path: AppRoutes.chooseLevel,
        builder: (_, _) => const ChooseLevelScreen(),
      ),

      // The five main tabs
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, _) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.daily,
                builder: (_, _) => const DailyChallengeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.leaderboard,
                builder: (_, _) => const LeaderboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.progress,
                builder: (_, _) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Pages opened on top of the tabs
      GoRoute(
        path: AppRoutes.lesson,
        builder: (_, state) =>
            LessonScreen(stageId: state.pathParameters['stageId']!),
      ),
      GoRoute(
        path: AppRoutes.stageComplete,
        builder: (_, state) {
          final q = state.uri.queryParameters;
          return StageCompleteScreen(
            stars: int.tryParse(q['stars'] ?? '') ?? 3,
            xp: int.tryParse(q['xp'] ?? '') ?? 0,
            accuracy: int.tryParse(q['accuracy'] ?? '') ?? 0,
            combo: int.tryParse(q['combo'] ?? '') ?? 1,
            next: q['next'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.levelUp,
        builder: (_, state) {
          final q = state.uri.queryParameters;
          return LevelUpScreen(
            level: int.tryParse(q['level'] ?? '') ?? 2,
            next: q['next'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.badge,
        builder: (_, state) {
          final q = state.uri.queryParameters;
          return BadgeUnlockedScreen(
            name: q['name'] ?? 'New badge',
            description: q['desc'] ?? '',
            next: q['next'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        builder: (_, _) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: AppRoutes.deleteAccount,
        builder: (_, _) => const DeleteAccountScreen(),
      ),
    ],
  );
});
