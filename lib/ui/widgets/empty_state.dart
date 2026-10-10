import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_typography.dart';

/// A calm line drawing of a low sun over a horizon with a title and hint.
class EmptyState extends StatelessWidget {
  const EmptyState({required this.title, required this.body, super.key});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 132, height: 72, child: CustomPaint(painter: _HorizonPainter())),
        const SizedBox(height: 28),
        Text(title, style: KlarTypography.title, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(body, style: KlarTypography.bodyMuted, textAlign: TextAlign.center),
      ],
    ),
  );
}

class _HorizonPainter extends CustomPainter {
  const _HorizonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = KlarColors.lineStrong
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final sun = Paint()
      ..color = KlarColors.birch.withValues(alpha: 0.85)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final horizon = size.height * 0.72;
    final center = Offset(size.width / 2, horizon);
    canvas
      ..save()
      ..clipRect(Rect.fromLTWH(0, 0, size.width, horizon))
      ..drawCircle(center, size.height * 0.42, sun)
      ..restore();
    for (var i = 0; i < 5; i++) {
      final angle = math.pi + math.pi * (i + 1) / 6;
      final from = center + Offset(math.cos(angle), math.sin(angle)) * size.height * 0.55;
      final to = center + Offset(math.cos(angle), math.sin(angle)) * size.height * 0.68;
      canvas.drawLine(from, to, sun..strokeWidth = 1.2);
    }
    canvas
      ..drawLine(Offset(0, horizon), Offset(size.width, horizon), line)
      ..drawLine(Offset(size.width * 0.18, horizon + 10), Offset(size.width * 0.82, horizon + 10), line)
      ..drawLine(Offset(size.width * 0.34, horizon + 20), Offset(size.width * 0.66, horizon + 20), line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
