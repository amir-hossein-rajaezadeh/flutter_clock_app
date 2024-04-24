import 'dart:math';

import 'package:flutter/material.dart';

class HourHandPainter extends CustomPainter {
  final Paint hourHandPaint;
  int hours;
  int minutes;

  HourHandPainter({required this.hours, required this.minutes})
      : hourHandPaint = Paint() {
    hourHandPaint.color = const Color(0xffc5cbdd);
    hourHandPaint.style = PaintingStyle.stroke;
    hourHandPaint.strokeWidth = 6.0;
    hourHandPaint.strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);

    canvas.rotate(hours >= 12
        ? 2 * pi * ((hours - 12) / 12 + (minutes / 720))
        : 2 * pi * ((hours / 12) + (minutes / 720)));

    Path path = Path();
    path.moveTo(0.0, -radius * 0.5);
    path.lineTo(0.0, radius * 0.1);

    canvas.drawPath(path, hourHandPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(HourHandPainter oldDelegate) {
    return true;
  }
}
