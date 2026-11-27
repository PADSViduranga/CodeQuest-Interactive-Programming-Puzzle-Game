import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/chunky_button.dart';
import '../../../../core/widgets/mito_logo.dart';
import '../../../../core/widgets/mode_toggle_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _PopIn(
                        duration: Duration(milliseconds: 1000),
                        curve: Interval(0.5, 1.0, curve: Curves.easeOutBack),
                        child: _SpeechBubble('Ready to code?'),
                      ),
                      const SizedBox(height: 4),
                      const _PopIn(
                        duration: Duration(milliseconds: 800),
                        curve: Curves.elasticOut,
                        child: MitoLogo(size: 150, animate: true),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'CodeQuest',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Solve puzzles, win XP and learn to code with Mito.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 36),
                      ChunkyButton(
                        label: 'GET STARTED',
                        onPressed: () => context.push('/register'),
                      ),
                      const SizedBox(height: 14),
                      ChunkyButton(
                        label: 'I ALREADY HAVE AN ACCOUNT',
                        secondary: true,
                        onPressed: () => context.push('/login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(top: 12, right: 16, child: ModeToggleButton()),
          ],
        ),
      ),
    );
  }
}

/// Scales and fades its child in once, when it first appears.
class _PopIn extends StatelessWidget {
  const _PopIn({
    required this.child,
    required this.duration,
    required this.curve,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: curve,
      child: child,
      builder: (context, v, child) => Opacity(
        opacity: v.clamp(0.0, 1.0),
        child: Transform.scale(scale: v, child: child),
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary, width: 2.5),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -7),
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: const Border(
                  right: BorderSide(color: AppColors.primary, width: 2.5),
                  bottom: BorderSide(color: AppColors.primary, width: 2.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
