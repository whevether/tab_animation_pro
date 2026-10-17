import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

enum TwinkleKind { star, moon }

/// Shared particle geometry and repaint-only animation for twinkle effects.
class TwinklePainter extends CustomPainter {
  TwinklePainter({
    required this.progress,
    required this.color,
    required this.kind,
    this.count = 5,
    this.animation,
  }) : super(repaint: animation);

  final double progress;
  final Color color;
  final TwinkleKind kind;
  final int count;
  final Animation<double>? animation;

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation?.value ?? progress;
    final moon = kind == TwinkleKind.moon;
    final center = Offset(size.width / 2, size.height * (moon ? 0.42 : 0.38));
    final paint = Paint();
    final rng = math.Random(moon ? 11 : 7);
    for (var i = 0; i < count; i++) {
      final phase = i / count * math.pi * 2;
      final spark = Curves.easeInOut.transform(
        (math.sin(t * math.pi * 2 + phase) + 1) / 2,
      );
      final angle = phase + t * (moon ? 0.28 : 0.35);
      final radius =
          (moon ? 12.0 : 14.0) +
          (i % 3) * (moon ? 6 : 5) +
          rng.nextDouble() * 2;
      final c =
          center +
          Offset(
            math.cos(angle) * radius,
            math.sin(angle) * radius * (moon ? 0.85 : 0.75) - (moon ? 0 : 4),
          );
      final r = (moon ? 2.4 : 2.2) + spark * (moon ? 2.6 : 2.8);
      paint.color = color.withValues(
        alpha: (moon ? 0.22 : 0.25) + spark * (moon ? 0.78 : 0.75),
      );
      canvas.drawPath(moon ? _crescentPath(c, r) : _starPath(c, r), paint);
    }
  }

  Path _starPath(Offset c, double r) {
    final path = Path();
    for (var i = 0; i < 4; i++) {
      final a = -math.pi / 2 + i * math.pi / 2;
      final outer = c + Offset(math.cos(a), math.sin(a)) * r;
      final inner =
          c +
          Offset(math.cos(a + math.pi / 4), math.sin(a + math.pi / 4)) *
              (r * 0.35);
      if (i == 0) {
        path.moveTo(outer.dx, outer.dy);
      } else {
        path.lineTo(outer.dx, outer.dy);
      }
      path.lineTo(inner.dx, inner.dy);
    }
    return path..close();
  }

  Path _crescentPath(Offset c, double r) => Path.combine(
    PathOperation.difference,
    Path()..addOval(Rect.fromCircle(center: c, radius: r)),
    Path()..addOval(
      Rect.fromCircle(
        center: c + Offset(-r * 0.45, -r * 0.08),
        radius: r * 0.78,
      ),
    ),
  );

  @override
  bool shouldRepaint(covariant TwinklePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.count != count ||
      oldDelegate.kind != kind ||
      oldDelegate.animation != animation;
}

class TwinkleOverlay extends StatefulWidget {
  const TwinkleOverlay({
    super.key,
    required this.progress,
    required this.active,
    required this.color,
    required this.kind,
    required this.child,
    this.animate = false,
  });
  final double progress;
  final bool active;
  final Color color;
  final TwinkleKind kind;
  final Widget child;
  final bool animate;

  @override
  State<TwinkleOverlay> createState() => _TwinkleOverlayState();
}

class _TwinkleOverlayState extends State<TwinkleOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(covariant TwinkleOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    if (widget.active && widget.animate) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return widget.child;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: TwinklePainter(
                progress: widget.progress,
                color: widget.color,
                kind: widget.kind,
                animation: widget.animate ? _controller : null,
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}
