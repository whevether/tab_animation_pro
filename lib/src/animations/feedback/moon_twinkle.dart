import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Twinkling crescent moons around the selected tab (icon + label).
class MoonTwinklePainter extends CustomPainter {
  MoonTwinklePainter({
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
    final cy = size.height * 0.42;
    final paint = Paint()..style = PaintingStyle.fill;
    final rng = math.Random(11);

    for (var i = 0; i < count; i++) {
      final phase = (i / count) * math.pi * 2;
      final twinkle = (math.sin(progress * math.pi * 2 + phase) + 1) / 2;
      final spark = Curves.easeInOut.transform(twinkle);
      final angle = phase + progress * 0.28;
      final radius = 12.0 + (i % 3) * 6.0 + rng.nextDouble() * 2;
      final x = cx + math.cos(angle) * radius;
      final y = cy + math.sin(angle) * radius * 0.85;
      final moonR = 2.4 + spark * 2.6;
      paint.color = color.withValues(alpha: 0.22 + spark * 0.78);
      canvas.drawPath(_crescentPath(Offset(x, y), moonR), paint);
    }
  }

  /// Crescent facing one way (opening to the left, like 🌙).
  Path _crescentPath(Offset c, double r) {
    final outer = Path()..addOval(Rect.fromCircle(center: c, radius: r));
    final cut = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(c.dx - r * 0.45, c.dy - r * 0.08),
          radius: r * 0.78,
        ),
      );
    return Path.combine(PathOperation.difference, outer, cut);
  }

  @override
  bool shouldRepaint(covariant MoonTwinklePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// Wraps a tab slot (icon + label) with twinkling moons when selected.
class MoonTwinkleOverlay extends StatelessWidget {
  const MoonTwinkleOverlay({
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
            painter: MoonTwinklePainter(progress: progress, color: color),
          ),
        ),
        child,
      ],
    );
  }
}
