import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

/// Marks every widget as needing a rebuild so colors read from AppColors
/// are picked up everywhere after a light/dark switch.
void _rebuildEverything() {
  void visit(Element element) {
    element.markNeedsBuild();
    element.visitChildren(visit);
  }

  WidgetsBinding.instance.rootElement?.visitChildren(visit);
}

class CodeQuestApp extends ConsumerWidget {
  const CodeQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(settingsProvider.select((s) => s.darkMode));

    // After the new theme has been built once, rebuild every screen so
    // widgets that don't depend on the theme refresh their colors too.
    ref.listen<bool>(settingsProvider.select((s) => s.darkMode), (_, _) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => _rebuildEverything(),
      );
    });

    // Only the active theme is built, so AppColors always matches it.
    final theme = dark ? AppTheme.dark : AppTheme.light;
    return MaterialApp.router(
      title: 'CodeQuest',
      debugShowCheckedModeBanner: false,
      theme: theme,
      themeMode: ThemeMode.light,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
