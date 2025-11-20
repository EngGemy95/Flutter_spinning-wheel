import 'dart:math';

import 'package:flutter/material.dart';

class WheelPainter extends CustomPainter {
  final List<String> names;
  final List<String> charNames;
  final List<Color> colors;
  final double currentAngle;

  WheelPainter(
      {required this.names, required this.charNames, required this.currentAngle, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final anglePerSection = 2 * pi / names.length;
    final paint = Paint()..style = PaintingStyle.fill;
    final radius = size.width / 2;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(currentAngle);

    for (int i = 0; i < names.length; i++) {
      paint.color = colors[i];

      final path = Path()
        ..moveTo(0, 0)
        ..arcTo(Rect.fromCircle(center: Offset.zero, radius: radius),
            i * anglePerSection, anglePerSection, false)
        ..close();

      canvas.drawPath(path, paint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: charNames[i],
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();

      final angle = (i * anglePerSection) + (anglePerSection / 2);
      final textX = cos(angle) * radius * 0.5;
      final textY = sin(angle) * radius * 0.5;

      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(angle);

      textPainter.paint(
          canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant WheelPainter oldDelegate) =>
      oldDelegate.currentAngle != currentAngle;
}
