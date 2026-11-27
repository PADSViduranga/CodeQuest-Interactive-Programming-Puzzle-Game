import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// One of the Mito avatars a player can pick.
class AvatarOption {
  const AvatarOption(this.id, this.icon, this.colors);

  final String id;
  final IconData icon;
  final List<Color> colors;
}

const avatarOptions = [
  AvatarOption('mito_1', Icons.bolt, [Color(0xFF2DD4BF), Color(0xFF5CC8F5)]),
  AvatarOption('mito_2', Icons.rocket_launch, [
    Color(0xFF22D3EE),
    Color(0xFF6366F1),
  ]),
  AvatarOption('mito_3', Icons.pets, [Color(0xFFFFC857), Color(0xFFFF7A45)]),
  AvatarOption('mito_4', Icons.code, [Color(0xFF8BE04E), Color(0xFF2DD4BF)]),
  AvatarOption('mito_5', Icons.sports_esports, [
    Color(0xFFFF4FA3),
    Color(0xFFFF7A45),
  ]),
  AvatarOption('mito_6', Icons.auto_awesome, [
    Color(0xFFFFE14D),
    Color(0xFFFF8FA3),
  ]),
];

/// Finds an avatar by id. Unknown ids fall back to the first avatar.
AvatarOption avatarFor(String id) => avatarOptions.firstWhere(
  (a) => a.id == id,
  orElse: () => avatarOptions.first,
);

/// A round, glowing avatar. Use it anywhere the player's face is shown.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.avatarId,
    this.size = 48,
    this.selected = false,
  });

  final String avatarId;
  final double size;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final a = avatarFor(avatarId);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: a.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: selected
            ? Border.all(color: AppColors.textPrimary, width: 3)
            : null,
        boxShadow: [
          BoxShadow(
            color: a.colors.last.withValues(alpha: 0.45),
            blurRadius: size * 0.3,
          ),
        ],
      ),
      child: Icon(a.icon, color: Colors.white, size: size * 0.5),
    );
  }
}
