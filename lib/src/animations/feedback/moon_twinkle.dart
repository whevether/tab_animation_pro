import 'package:material_ui/material_ui.dart';

import 'twinkle.dart';

/// Moon particles; changing [count] invalidates the painted output.
class MoonTwinklePainter extends TwinklePainter {
  MoonTwinklePainter({
    required super.progress,
    required super.color,
    super.count,
    super.animation,
  }) : super(kind: TwinkleKind.moon);
}

/// Wraps a tab slot with moon particles when selected.
class MoonTwinkleOverlay extends StatelessWidget {
  const MoonTwinkleOverlay({
    super.key,
    required this.progress,
    required this.active,
    required this.color,
    required this.child,
    this.animate = false,
  });
  final double progress;
  final bool active;
  final Color color;
  final Widget child;
  final bool animate;

  @override
  Widget build(BuildContext context) => TwinkleOverlay(
    progress: progress,
    active: active,
    color: color,
    kind: TwinkleKind.moon,
    animate: animate,
    child: child,
  );
}
