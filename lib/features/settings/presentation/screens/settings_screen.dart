import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const _Section('Gameplay'),
          _SwitchRow(
            title: 'Sound effects',
            subtitle: 'Taps, wins and level ups',
            value: settings.sound,
            onChanged: notifier.setSound,
          ),
          _SwitchRow(
            title: 'Haptics',
            subtitle: 'Vibrate on answers',
            value: settings.haptics,
            onChanged: notifier.setHaptics,
          ),
          const SizedBox(height: 12),
          const _Section('Account'),
          _TapRow(
            title: 'Privacy policy',
            icon: Icons.chevron_right,
            onTap: () => context.push('/privacy'),
          ),
          _TapRow(
            title: 'Log out',
            icon: Icons.logout,
            onTap: () => ref.read(authRepositoryProvider).signOut(),
          ),
          if (user != null && !user.isGuest)
            _TapRow(
              title: 'Delete account',
              subtitle: 'Erase all your data',
              icon: Icons.chevron_right,
              danger: true,
              onTap: () => context.push('/delete-account'),
            ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.textSecondary,
      ),
    ),
  );
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
      value: value,
      onChanged: onChanged,
    ),
  );
}

class _TapRow extends StatelessWidget {
  const _TapRow({
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.danger = false,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : AppColors.textPrimary;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: danger ? AppColors.dangerTint : null,
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: color),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
        trailing: Icon(
          icon,
          color: danger ? AppColors.danger : AppColors.primaryLight,
        ),
      ),
    );
  }
}
