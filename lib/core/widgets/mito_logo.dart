import 'package:flutter/material.dart';

/// Mito, the CodeQuest mascot. It is drawn in code, so it stays sharp at any
/// size and needs no image files.
class MitoLogo extends StatelessWidget {
  const MitoLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          colors: [Color(0xFF9F5CFF), Color(0xFFFF4FA3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9F5CFF).withValues(alpha: 0.5),
            blurRadius: size * 0.3,
          ),
        ],
      ),
      child: CustomPaint(painter: _MitoPainter()),
    );
  }
}

class _MitoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final white = Paint()..color = Colors.white;
    final dark = Paint()..color = const Color(0xFF1B1035);

    // Eyes
    for (final dx in [-0.18, 0.18]) {
      final c = Offset(s * (0.5 + dx), s * 0.5);
      canvas.drawOval(
        Rect.fromCenter(center: c, width: s * 0.2, height: s * 0.26),
        white,
      );
      canvas.drawCircle(c.translate(0, s * 0.02), s * 0.055, dark);
      canvas.drawCircle(c.translate(-s * 0.02, -s * 0.025), s * 0.02, white);
    }

    // Smile
    final smile = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.05
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(s * 0.5, s * 0.62),
        width: s * 0.3,
        height: s * 0.2,
      ),
      0.2,
      2.74,
      false,
      smile,
    );

    // Lightning antenna
    final bolt = Path()
      ..moveTo(s * 0.54, s * 0.10)
      ..lineTo(s * 0.44, s * 0.26)
      ..lineTo(s * 0.50, s * 0.26)
      ..lineTo(s * 0.46, s * 0.38)
      ..lineTo(s * 0.58, s * 0.21)
      ..lineTo(s * 0.51, s * 0.21)
      ..close();
    canvas.drawPath(bolt, Paint()..color = const Color(0xFFFFC857));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
