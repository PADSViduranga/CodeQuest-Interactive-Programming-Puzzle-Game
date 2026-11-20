import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ConfettiOverlay extends StatelessWidget {
  const ConfettiOverlay({super.key, required this.child, this.visible = true});
  final Widget child;
  final bool visible;
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      child,
      if (visible)
        IgnorePointer(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 28),
              child: Wrap(
                spacing: 18,
                children: const [
                  Icon(Icons.star, color: AppColors.yellow),
                  Icon(Icons.circle, color: AppColors.cyan),
                  Icon(Icons.square, color: AppColors.green),
                  Icon(Icons.star, color: AppColors.primaryLight),
                ],
              ),
            ),
          ),
        ),
    ],
  );
}
