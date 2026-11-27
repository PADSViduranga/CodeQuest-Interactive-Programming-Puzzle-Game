import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/presentation/providers/settings_provider.dart';
import '../theme/app_colors.dart';

/// A small sun/moon button that switches between light and dark mode.
class ModeToggleButton extends ConsumerWidget {
  const ModeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(settingsProvider.select((s) => s.darkMode));
    return Semantics(
      button: true,
      label: dark ? 'Switch to light mode' : 'Switch to dark mode',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => ref.read(settingsProvider.notifier).setDarkMode(!dark),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 2),
          ),
          child: Icon(
            dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            size: 22,
            color: dark ? AppColors.yellow : AppColors.primaryDark,
          ),
        ),
      ),
    );
  }
}
