import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Sparkle stars around the selected tab (feedback / indicator accent).
class StarTwinklePainter extends CustomPainter {
  StarTwinklePainter({
    required this.progress,
    required this.color,
    this.count = 5,
  });

  final double progress;
  final Color color;
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.38;
    final paint = Paint()..style = PaintingStyle.fill;
    final rng = math.Random(7);

    for (var i = 0; i < count; i++) {
      final phase = (i / count) * math.pi * 2;
      final twinkle = (math.sin(progress * math.pi * 2 + phase) + 1) / 2;
      final spark = Curves.easeInOut.transform(twinkle);
      final angle = phase + progress * 0.35;
      final radius = 14.0 + (i % 3) * 5.0 + rng.nextDouble() * 2;
      final x = cx + math.cos(angle) * radius;
      final y = cy + math.sin(angle) * radius * 0.75 - 4;
      final starR = 2.2 + spark * 2.8;
      paint.color = color.withValues(alpha: 0.25 + spark * 0.75);
      canvas.drawPath(_starPath(Offset(x, y), starR), paint);
    }
  }

  Path _starPath(Offset c, double r) {
    final path = Path();
    for (var i = 0; i < 4; i++) {
      final a = -math.pi / 2 + i * math.pi / 2;
      final outer = Offset(c.dx + math.cos(a) * r, c.dy + math.sin(a) * r);
      final midA = a + math.pi / 4;
      final inner = Offset(
        c.dx + math.cos(midA) * r * 0.35,
        c.dy + math.sin(midA) * r * 0.35,
      );
      if (i == 0) {
        path.moveTo(outer.dx, outer.dy);
      } else {
        path.lineTo(outer.dx, outer.dy);
      }
      path.lineTo(inner.dx, inner.dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant StarTwinklePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// Wraps a tab slot with twinkling stars when selected.
class StarTwinkleOverlay extends StatelessWidget {
  const StarTwinkleOverlay({
    super.key,
    required this.progress,
    required this.active,
    required this.color,
    required this.child,
  });

  final double progress;
  final bool active;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!active) return child;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: StarTwinklePainter(progress: progress, color: color),
          ),
        ),
        child,
      ],
    );
  }
}
