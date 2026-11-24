import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MitoLogo extends StatelessWidget {
  const MitoLogo({super.key, this.size = 96});
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _MitoPainter()),
      );
}

class _MitoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 64);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Paint fill(Color c) => Paint()..color = c;

    canvas.drawLine(
      const Offset(32, 5),
      const Offset(32, 13),
      stroke
        ..color = AppColors.cyan
        ..strokeWidth = 3,
    );
    canvas.drawCircle(const Offset(32, 5), 4, fill(AppColors.yellow));

    final body = RRect.fromLTRBR(8, 12, 56, 52, const Radius.circular(14));
    canvas.drawRRect(body, fill(const Color(0xFF2A1A6E)));
    canvas.drawRRect(
      body,
      stroke
        ..color = AppColors.primaryLight
        ..strokeWidth = 2.5,
    );

    canvas.drawRRect(
      RRect.fromLTRBR(15, 21, 49, 43, const Radius.circular(9)),
      fill(AppColors.background),
    );
    canvas.drawCircle(const Offset(25, 32), 4.5, fill(AppColors.cyan));
    canvas.drawCircle(const Offset(39, 32), 4.5, fill(AppColors.cyan));

    final mouth = Path()
      ..moveTo(27, 39)
      ..quadraticBezierTo(32, 43, 37, 39);
    canvas.drawPath(
      mouth,
      stroke
        ..color = AppColors.green
        ..strokeWidth = 2.2,
    );

    canvas.drawRRect(
      RRect.fromLTRBR(2, 26, 8, 38, const Radius.circular(3)),
      fill(AppColors.primary),
    );
    canvas.drawRRect(
      RRect.fromLTRBR(56, 26, 62, 38, const Radius.circular(3)),
      fill(AppColors.primary),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
