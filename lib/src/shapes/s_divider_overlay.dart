import 'package:material_ui/material_ui.dart';

import 'bar_shapes.dart';
import 'piano_keys_painter.dart';

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
    paintTabSeams(canvas, paths, color: color, strokeWidth: strokeWidth);
  }

  @override
  bool shouldRepaint(covariant _SDividerPainter oldDelegate) {
    return oldDelegate.itemCount != itemCount ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.bend != bend;
  }
}
