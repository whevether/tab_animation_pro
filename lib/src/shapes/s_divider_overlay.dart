import 'package:flutter/material.dart';

import '../shapes/bar_shapes.dart';

/// Paints S-curve divider strokes between tab items ([TabBarShape.sDivider]).
class SDividerOverlay extends StatelessWidget {
  const SDividerOverlay({
    super.key,
    required this.itemCount,
    required this.color,
    this.strokeWidth = 1.5,
    this.bend = 10,
  });

  final int itemCount;
  final Color color;
  final double strokeWidth;
  final double bend;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SDividerPainter(
        itemCount: itemCount,
        color: color,
        strokeWidth: strokeWidth,
        bend: bend,
      ),
      size: Size.infinite,
    );
  }
}

class _SDividerPainter extends CustomPainter {
  _SDividerPainter({
    required this.itemCount,
    required this.color,
    required this.strokeWidth,
    required this.bend,
  });

  final int itemCount;
  final Color color;
  final double strokeWidth;
  final double bend;

  @override
  void paint(Canvas canvas, Size size) {
    final paths = buildSDividerPaths(
      size: size,
      itemCount: itemCount,
      bend: bend,
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    for (final path in paths) {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SDividerPainter oldDelegate) {
    return oldDelegate.itemCount != itemCount ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.bend != bend;
  }
}
