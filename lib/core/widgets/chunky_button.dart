import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A chunky game button with a solid edge underneath that presses down.
class ChunkyButton extends StatefulWidget {
  const ChunkyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.secondary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool secondary;

  @override
  State<ChunkyButton> createState() => _ChunkyButtonState();
}

class _ChunkyButtonState extends State<ChunkyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final face = widget.secondary ? AppColors.surface : AppColors.primary;
    final edge = widget.secondary ? AppColors.border : AppColors.primaryDark;
    final text = widget.secondary
        ? AppColors.primaryLight
        : AppColors.onPrimary;

    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 70),
          margin: EdgeInsets.only(top: _pressed ? 3 : 0),
          padding: EdgeInsets.only(bottom: _pressed ? 2 : 5),
          decoration: BoxDecoration(
            color: edge,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: face,
              borderRadius: BorderRadius.circular(18),
              border: widget.secondary
                  ? Border.all(color: AppColors.border, width: 2)
                  : null,
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: text,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
