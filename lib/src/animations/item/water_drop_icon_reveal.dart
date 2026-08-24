import 'dart:ui' show lerpDouble;

import 'package:material_ui/material_ui.dart';

/// Circular reveal used by water_drop_nav_bar `IconClipper`.
class _CircleRevealClipper extends CustomClipper<Rect> {
  _CircleRevealClipper(this.radius);

  final double radius;

  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );
  }

  @override
  bool shouldReclip(covariant _CircleRevealClipper oldClipper) {
    return oldClipper.radius != radius;
  }
}

double _interval(double t, double begin, double end) {
  if (end <= begin) return t >= end ? 1 : 0;
  return ((t - begin) / (end - begin)).clamp(0.0, 1.0);
}

/// Inactive outline + filled icon revealed by a falling drop
/// (water_drop_nav_bar `BuildIconButton` timing).
class WaterDropIconReveal extends StatelessWidget {
  const WaterDropIconReveal({
    super.key,
    required this.progress,
    required this.selected,
    required this.inactiveIcon,
    required this.activeIcon,
    this.iconSize = 28,
  });

  final double progress;
  final bool selected;
  final Widget inactiveIcon;
  final Widget activeIcon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final t = progress.clamp(0.0, 1.0);
    final bottomScale = selected ? lerpDouble(1.0, 0.7, _interval(t, 0.55, 1.0))! : 1.0;
    final topScale = lerpDouble(0.7, 1.0, _interval(t, 0.55, 1.0))!;
    final clipR = lerpDouble(0, 30, _interval(t, 0.60, 1.0))!;
    final hideOutline = t > 0.8 && selected;
    final showFilled = t > 0.6 && selected;

    return SizedBox(
      width: iconSize + 8,
      height: iconSize + 8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: bottomScale,
            child: Opacity(
              opacity: hideOutline ? 0 : 1,
              child: inactiveIcon,
            ),
          ),
          Transform.scale(
            scale: topScale,
            child: ClipOval(
              clipper: _CircleRevealClipper(clipR),
              child: Opacity(
                opacity: showFilled ? 1 : 0,
                child: activeIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
