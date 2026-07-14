import 'package:flutter/material.dart';

/// A cheerful "running coffee cup" mascot, drawn as an original vector
/// illustration (no external image asset required). Inspired by a running
/// take-out cup character: lid on top, a body band, kicking legs and
/// waving arms, and a simple smiling face.
class MascotAvatar extends StatelessWidget {
  const MascotAvatar({
    super.key,
    this.size = 72,
    this.backgroundColor = const Color(0xFFEDE6D8),
    this.ringColor = const Color(0xFFC9B892),
    this.cupColor = const Color(0xFFEFE9DC),
    this.lidColor = const Color(0xFFFAF7F0),
    this.limbColor = const Color(0xFF3A2E22),
    this.lineColor = const Color(0xFF3A2E22),
  });

  final double size;
  final Color backgroundColor;
  final Color ringColor;
  final Color cupColor;
  final Color lidColor;
  final Color limbColor;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: size * 0.02),
      ),
      padding: EdgeInsets.all(size * 0.14),
      child: CustomPaint(
        painter: _MascotPainter(
          cupColor: cupColor,
          lidColor: lidColor,
          limbColor: limbColor,
          lineColor: lineColor,
        ),
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  _MascotPainter({
    required this.cupColor,
    required this.lidColor,
    required this.limbColor,
    required this.lineColor,
  });

  final Color cupColor;
  final Color lidColor;
  final Color limbColor;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final outline = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // --- Legs (drawn first, so the cup body sits on top of them) ---
    final legPaint = Paint()
      ..color = limbColor
      ..style = PaintingStyle.fill;

    // Left leg: bent, kicking back-left.
    final leftLeg = Path()
      ..moveTo(w * 0.40, h * 0.78)
      ..quadraticBezierTo(w * 0.28, h * 0.86, w * 0.20, h * 0.80)
      ..quadraticBezierTo(w * 0.16, h * 0.90, w * 0.26, h * 0.94)
      ..quadraticBezierTo(w * 0.38, h * 0.96, w * 0.46, h * 0.86)
      ..close();
    canvas.drawPath(leftLeg, legPaint);

    // Right leg: bent, kicking forward-right.
    final rightLeg = Path()
      ..moveTo(w * 0.60, h * 0.78)
      ..quadraticBezierTo(w * 0.74, h * 0.82, w * 0.78, h * 0.74)
      ..quadraticBezierTo(w * 0.86, h * 0.78, w * 0.84, h * 0.88)
      ..quadraticBezierTo(w * 0.74, h * 0.94, w * 0.58, h * 0.86)
      ..close();
    canvas.drawPath(rightLeg, legPaint);

    // --- Arms ---
    final armStroke = Paint()
      ..color = limbColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round;

    final leftArm = Path()
      ..moveTo(w * 0.30, h * 0.52)
      ..quadraticBezierTo(w * 0.10, h * 0.50, w * 0.08, h * 0.62);
    canvas.drawPath(leftArm, armStroke);
    canvas.drawCircle(Offset(w * 0.08, h * 0.63), w * 0.035, legPaint);

    final rightArm = Path()
      ..moveTo(w * 0.70, h * 0.52)
      ..quadraticBezierTo(w * 0.90, h * 0.48, w * 0.92, h * 0.58);
    canvas.drawPath(rightArm, armStroke);
    canvas.drawCircle(Offset(w * 0.92, h * 0.58), w * 0.035, legPaint);

    // --- Cup body ---
    final cupFill = Paint()
      ..color = cupColor
      ..style = PaintingStyle.fill;
    final cupBody = Path()
      ..moveTo(w * 0.32, h * 0.30)
      ..lineTo(w * 0.68, h * 0.30)
      ..lineTo(w * 0.62, h * 0.80)
      ..quadraticBezierTo(w * 0.50, h * 0.86, w * 0.38, h * 0.80)
      ..close();
    canvas.drawPath(cupBody, cupFill);
    canvas.drawPath(cupBody, outline);

    // Cup band (horizontal sleeve stripe).
    final bandPaint = Paint()
      ..color = lineColor.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    final band = Path()
      ..moveTo(w * 0.35, h * 0.52)
      ..lineTo(w * 0.65, h * 0.52)
      ..lineTo(w * 0.635, h * 0.66)
      ..lineTo(w * 0.365, h * 0.66)
      ..close();
    canvas.drawPath(band, bandPaint);
    canvas.drawLine(
      Offset(w * 0.35, h * 0.52),
      Offset(w * 0.65, h * 0.52),
      outline,
    );
    canvas.drawLine(
      Offset(w * 0.365, h * 0.66),
      Offset(w * 0.635, h * 0.66),
      outline,
    );

    // --- Lid ---
    final lidFill = Paint()
      ..color = lidColor
      ..style = PaintingStyle.fill;
    final lidRect = Rect.fromLTWH(w * 0.28, h * 0.22, w * 0.44, h * 0.10);
    final lidRRect = RRect.fromRectAndRadius(lidRect, Radius.circular(w * 0.04));
    canvas.drawRRect(lidRRect, lidFill);
    canvas.drawRRect(lidRRect, outline);

    // Lid sip-lid nub on top.
    final nubRect = Rect.fromLTWH(w * 0.42, h * 0.16, w * 0.16, h * 0.08);
    final nubRRect = RRect.fromRectAndRadius(nubRect, Radius.circular(w * 0.03));
    canvas.drawRRect(nubRRect, lidFill);
    canvas.drawRRect(nubRRect, outline);

    // --- Face ---
    final facePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.44, h * 0.42), w * 0.03, facePaint);
    canvas.drawCircle(Offset(w * 0.56, h * 0.42), w * 0.03, facePaint);

    final mouth = Path()
      ..moveTo(w * 0.46, h * 0.47)
      ..quadraticBezierTo(w * 0.50, h * 0.50, w * 0.54, h * 0.47);
    canvas.drawPath(
      mouth,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.025
        ..strokeCap = StrokeCap.round,
    );

    // Little cheeks (optional charm).
    final cheekPaint = Paint()..color = const Color(0xFFE8A796).withOpacity(0.6);
    canvas.drawCircle(Offset(w * 0.38, h * 0.46), w * 0.025, cheekPaint);
    canvas.drawCircle(Offset(w * 0.62, h * 0.46), w * 0.025, cheekPaint);
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) {
    return oldDelegate.cupColor != cupColor ||
        oldDelegate.lidColor != lidColor ||
        oldDelegate.limbColor != limbColor ||
        oldDelegate.lineColor != lineColor;
  }
}