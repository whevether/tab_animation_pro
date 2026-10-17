import 'package:material_ui/material_ui.dart';

import 'twinkle.dart';

/// Star particles; changing [count] invalidates the painted output.
class StarTwinklePainter extends TwinklePainter {
  StarTwinklePainter({
    required super.progress,
    required super.color,
    super.count,
    super.animation,
  }) : super(kind: TwinkleKind.star);
}

/// Wraps a tab slot with star particles when selected.
class StarTwinkleOverlay extends StatelessWidget {
  const StarTwinkleOverlay({
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
    kind: TwinkleKind.star,
    animate: animate,
    child: child,
  );
}
