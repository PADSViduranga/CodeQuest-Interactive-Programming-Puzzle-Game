import 'package:flutter/material.dart';

import '../../../rewards/presentation/widgets/badges_section.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/avatar_circle.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final profile = ref.watch(playerProfileProvider).value;
    final name = profile?.displayName ?? user?.displayName ?? 'Player';
    final isGuest = user?.isGuest ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: AvatarCircle(
              avatarId: profile?.avatarId ?? 'mito_1',
              size: 92,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            isGuest ? 'Guest player' : (user?.email ?? ''),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  label: 'Level',
                  value: '${profile?.level ?? 1}',
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Stat(
                  label: 'Total XP',
                  value: '${profile?.totalXp ?? 0}',
                  color: AppColors.yellow,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Stat(
                  label: 'Day streak',
                  value: '${profile?.currentStreak ?? 0}',
                  color: AppColors.pink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          BadgesSection(earned: profile?.badges ?? const []),
          const SizedBox(height: 20),
          if (isGuest)
            Card(
              color: AppColors.yellowTint,
              child: ListTile(
                leading: const Icon(Icons.bolt, color: AppColors.yellow),
                title: const Text('Create an account to keep your progress'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/register'),
              ),
            ),
          Card(
            child: ListTile(
              leading: Icon(Icons.edit_outlined, color: AppColors.primaryLight),
              title: const Text('Edit profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/edit-profile'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.settings_outlined,
                color: AppColors.primaryLight,
              ),
              title: const Text('Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.logout, color: AppColors.primaryLight),
              title: const Text('Log out'),
              onTap: () => ref.read(authRepositoryProvider).signOut(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    ),
  );
}
