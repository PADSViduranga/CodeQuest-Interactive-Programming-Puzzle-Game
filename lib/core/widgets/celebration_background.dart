import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

/// Dark violet background with a glow, used by all reward screens.
class CelebrationBackground extends StatelessWidget {
  const CelebrationBackground({
    super.key,
    required this.child,
    this.glow = AppColors.primary,
  });

  final Widget child;
  final Color glow;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.5),
          radius: 1.0,
          colors: [glow.withValues(alpha: 0.45), AppColors.background],
          stops: const [0, 0.7],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: child,
        ),
      ),
    ),
  );
}

/// Opens the next screen in a chain, or goes home when there is none.
void goNext(BuildContext context, String? next) {
  if (next == null || next.isEmpty) {
    context.go('/home');
  } else {
    context.pushReplacement(next);
  }
}
