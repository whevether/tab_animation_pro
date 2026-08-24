import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:material_ui/material_ui.dart';

import '../models/enums.dart';

/// Builds a tab-sized 3D matrix. Angles stay mild so icons do not collapse.
Matrix4 tab3DMatrix({
  required Tab3DStyle style,
  required bool selected,
  required double progress,
  required int index,
  required int selectedIndex,
  required int previousIndex,
  double perspective = 0.0008,
}) {
  // Continuous focus position while switching tabs.
  final focus = lerpDouble(
        previousIndex.toDouble(),
        selectedIndex.toDouble(),
        progress.clamp(0.0, 1.0),
      ) ??
      selectedIndex.toDouble();
  final delta = (index - focus).clamp(-2.0, 2.0);
  final distance = delta.abs();
  final toward = 1.0 - distance.clamp(0.0, 1.0); // 1 at focus, 0 one+ away

  final m = Matrix4.identity()..setEntry(3, 2, perspective.clamp(0.0002, 0.0015));

  switch (style) {
    case Tab3DStyle.cube:
      // Adjacent faces: gentle Y tilt, focused face flat.
      m.rotateY(delta * 0.42);
      final s = 0.88 + 0.12 * toward;
      m.scaleByDouble(s, s, 1, 1);
    case Tab3DStyle.threeD:
      m.rotateY(delta * 0.28);
      m.translateByDouble(0, (1 - toward) * 3, distance * 12, 1);
      final s = 0.9 + 0.1 * toward;
      m.scaleByDouble(s, s, 1, 1);
    case Tab3DStyle.flip:
      // Flip only while switching; settled tabs stay upright.
      final animating = progress < 0.999;
      final isLeaving = index == previousIndex && previousIndex != selectedIndex;
      final isEntering = index == selectedIndex;
      if (isEntering) {
        m.rotateY(animating ? (1 - progress) * math.pi : 0);
      } else if (isLeaving && animating) {
        m.rotateY(progress * math.pi);
      } else {
        m.rotateY(delta.sign * math.min(distance, 1.0) * 0.06);
      }
    case Tab3DStyle.coverflow:
      m.rotateY(delta * 0.38);
      m.translateByDouble(delta * 6, 0, distance * 14, 1);
      final s = 0.84 + 0.16 * toward;
      m.scaleByDouble(s, s, 1, 1);
    case Tab3DStyle.carousel:
      final angle = delta * 0.32;
      m.rotateY(angle);
      m.translateByDouble(math.sin(angle) * 10, 0, (1 - math.cos(angle)) * 16, 1);
      final s = 0.86 + 0.14 * toward;
      m.scaleByDouble(s, s, 1, 1);
    case Tab3DStyle.cards:
      m.rotateZ(delta * 0.05);
      m.translateByDouble(delta * 3, (1 - toward) * 4, distance * 8, 1);
      final s = 0.88 + 0.12 * toward;
      m.scaleByDouble(s, s, 1, 1);
    case Tab3DStyle.rotate:
      // Swing up from the bottom edge of the icon.
      final animating = progress < 0.999;
      final active = index == selectedIndex ||
          (animating && index == previousIndex);
      final tilt = active
          ? (selected ? (1 - progress) : progress) * 0.5
          : distance * 0.1;
      m.rotateX(tilt);
      m.translateByDouble(0, tilt * 3, 0, 1);
  }
  return m;
}

class Tab3DTransform extends StatelessWidget {
  const Tab3DTransform({
    super.key,
    required this.style,
    required this.selected,
    required this.progress,
    required this.index,
    required this.selectedIndex,
    required this.previousIndex,
    required this.perspective,
    required this.child,
  });

  final Tab3DStyle style;
  final bool selected;
  final double progress;
  final int index;
  final int selectedIndex;
  final int previousIndex;
  final double perspective;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      filterQuality: FilterQuality.medium,
      transform: tab3DMatrix(
        style: style,
        selected: selected,
        progress: progress,
        index: index,
        selectedIndex: selectedIndex,
        previousIndex: previousIndex,
        perspective: perspective,
      ),
      child: child,
    );
  }
}
