import 'package:flutter/material.dart';

/// Paints interlocking piano-key tab silhouettes. The selected key briefly
/// presses in, then rests flush with the others.
class PianoKeysPainter extends CustomPainter {
  PianoKeysPainter({
    required this.keys,
    required this.selectedIndex,
    required this.previousIndex,
    required this.progress,
    required this.color,
    required this.pressedColor,
    this.seamColor = const Color(0x14000000),
    this.seams = const [],
    this.drawSeamsOnly = false,
    this.elevation = 2,
  });

  final List<Path> keys;
  final int selectedIndex;
  final int previousIndex;
  final double progress;
  final Color color;
  final Color pressedColor;
  final Color seamColor;
  final List<Path> seams;
  final bool drawSeamsOnly;
  final double elevation;

  @override
  void paint(Canvas canvas, Size size) {
    if (!drawSeamsOnly) {
      for (var i = 0; i < keys.length; i++) {
        final path = keys[i];
        var amount = 0.0;
        if (i == selectedIndex && i == previousIndex) {
          amount = 1;
        } else if (i == selectedIndex) {
          amount = progress;
        } else if (i == previousIndex) {
          amount = 1 - progress;
        }
        canvas.drawPath(
          path,
          Paint()
            ..color = Color.lerp(color, pressedColor, amount)!
            ..style = PaintingStyle.fill,
        );
      }
    }

    final seamPaint = Paint()
      ..color = seamColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawSeamsOnly ? 1.6 : 0.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    if (seams.isNotEmpty) {
      for (final seam in seams) {
        canvas.drawPath(seam, seamPaint);
      }
    } else {
      for (final path in keys) {
        canvas.drawPath(path, seamPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PianoKeysPainter oldDelegate) {
    return oldDelegate.keys != keys ||
        oldDelegate.seams != seams ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.previousIndex != previousIndex ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.pressedColor != pressedColor ||
        oldDelegate.seamColor != seamColor ||
        oldDelegate.drawSeamsOnly != drawSeamsOnly ||
        oldDelegate.elevation != elevation;
  }
}
