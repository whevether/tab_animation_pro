import 'package:material_ui/material_ui.dart';

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
    this.shadowColor = Colors.black26,
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
  final Color shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (!drawSeamsOnly) {
      if (elevation > 0) {
        final outline = Path();
        for (final key in keys) {
          outline.addPath(key, Offset.zero);
        }
        canvas.drawShadow(outline, shadowColor, elevation, true);
      }
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

    paintTabSeams(
      canvas,
      seams.isNotEmpty ? seams : keys,
      color: seamColor,
      strokeWidth: drawSeamsOnly ? 1.6 : 0.7,
    );
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
        oldDelegate.elevation != elevation ||
        oldDelegate.shadowColor != shadowColor;
  }
}

/// Shared seam rendering for the bar and the standalone divider overlay.
void paintTabSeams(
  Canvas canvas,
  Iterable<Path> paths, {
  required Color color,
  required double strokeWidth,
}) {
  final paint = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  for (final path in paths) {
    canvas.drawPath(path, paint);
  }
}
