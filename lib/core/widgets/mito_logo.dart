import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Mito, the CodeQuest mascot: a rounded body with eyes, a smile,
/// pink cheeks and a lightning-bolt antenna.
///
/// With [animate] set, Mito floats, blinks, wiggles his bolt now and then,
/// and hops with a bigger smile when tapped.
class MitoLogo extends StatefulWidget {
  const MitoLogo({super.key, this.size = 96, this.animate = false});

  final double size;
  final bool animate;

  @override
  State<MitoLogo> createState() => _MitoLogoState();
}

class _MitoLogoState extends State<MitoLogo> with TickerProviderStateMixin {
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  );
  late final AnimationController _tap = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _loop.repeat();
  }

  @override
  void dispose() {
    _loop.dispose();
    _tap.dispose();
    super.dispose();
  }

  // One blink every two seconds, as a quick close and open.
  double _blink(double t) {
    final u = (t * 2) % 1;
    if (u < 0.78 || u > 0.86) return 0;
    final v = (u - 0.78) / 0.08;
    return 1 - (2 * v - 1).abs();
  }

  // A small bolt wiggle once every two seconds.
  double _boltAngle(double t) {
    final u = (t * 2) % 1;
    if (u < 0.3 || u > 0.5) return 0;
    return math.sin((u - 0.3) / 0.2 * 2 * math.pi * 2) * 0.15;
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    if (!widget.animate) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _MitoPainter()),
      );
    }

    return GestureDetector(
      onTap: () => _tap.forward(from: 0),
      child: AnimatedBuilder(
        animation: Listenable.merge([_loop, _tap]),
        builder: (context, _) {
          final t = _loop.value;
          final k = _tap.value;
          final float = math.sin(t * 2 * math.pi * 2) * 3;
          final jump = math.sin(k * math.pi) * size * 0.14;
          final squash = 0.07 * math.sin(k * math.pi * 3) * (1 - k);
          return SizedBox(
            width: size,
            height: size,
            child: Transform.translate(
              offset: Offset(0, float - jump),
              child: Transform.scale(
                scaleX: 1 + squash,
                scaleY: 1 - squash,
                alignment: Alignment.bottomCenter,
                child: CustomPaint(
                  painter: _MitoPainter(
                    blink: _blink(t),
                    boltAngle: _boltAngle(t),
                    smile: math.sin(k * math.pi),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MitoPainter extends CustomPainter {
  _MitoPainter({this.blink = 0, this.boltAngle = 0, this.smile = 0});

  final double blink;
  final double boltAngle;
  final double smile;

  static const _outline = Color(0xFF04080E);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 150, size.height / 150);

    Paint fill(Color c) => Paint()..color = c;
    Paint line(double w) => Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final bolt = Path()
      ..moveTo(75, 8)
      ..lineTo(66, 30)
      ..lineTo(76, 30)
      ..lineTo(70, 48)
      ..lineTo(88, 24)
      ..lineTo(78, 24)
      ..lineTo(84, 8)
      ..close();
    canvas.save();
    canvas.translate(75, 48);
    canvas.rotate(boltAngle);
    canvas.translate(-75, -48);
    canvas.drawPath(bolt, fill(AppColors.yellow));
    canvas.drawPath(bolt, line(3));
    canvas.restore();

    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(22, 42, 106, 92),
      const Radius.circular(36),
    );
    canvas.drawRRect(body, fill(AppColors.primary));
    canvas.drawRRect(body, line(4));

    final open = 1 - 0.9 * blink;
    for (final x in [56.0, 94.0]) {
      canvas.save();
      canvas.translate(x, 82);
      canvas.scale(1, open);
      canvas.drawCircle(Offset.zero, 14, fill(Colors.white));
      canvas.drawCircle(Offset.zero, 14, line(3));
      canvas.drawCircle(const Offset(3, 2), 6, fill(_outline));
      canvas.drawCircle(const Offset(5, 0), 2, fill(Colors.white));
      canvas.restore();
    }

    final smilePath = Path()
      ..moveTo(60, 108 - 2 * smile)
      ..quadraticBezierTo(75, 122 + 12 * smile, 90, 108 - 2 * smile);
    canvas.drawPath(smilePath, line(4));

    const cheek = Color(0xFFFFB3C7);
    canvas.drawCircle(const Offset(40, 104), 7, fill(cheek));
    canvas.drawCircle(const Offset(110, 104), 7, fill(cheek));
  }

  @override
  bool shouldRepaint(covariant _MitoPainter old) =>
      old.blink != blink || old.boltAngle != boltAngle || old.smile != smile;
}
