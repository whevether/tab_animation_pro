import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/enums.dart';

/// Applies [TabItemAnimation] transforms around tab content.
class TabItemMotion extends StatelessWidget {
  const TabItemMotion({
    super.key,
    required this.animation,
    required this.selected,
    required this.progress,
    required this.index,
    required this.selectedIndex,
    required this.child,
    this.label,
    this.showLabel = true,
    this.labelColor,
  });

  final TabItemAnimation animation;
  final bool selected;
  final double progress;
  final int index;
  final int selectedIndex;
  final Widget child;
  final String? label;
  final bool showLabel;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final t = selected ? progress : (1 - progress).clamp(0.0, 1.0);
    Widget content = child;

    switch (animation) {
      case TabItemAnimation.none:
      case TabItemAnimation.colorTween:
      case TabItemAnimation.custom:
        break;
      case TabItemAnimation.fade:
        content = Opacity(opacity: selected ? (0.55 + 0.45 * t) : 0.55, child: content);
      case TabItemAnimation.scale:
        content = Transform.scale(scale: selected ? (0.9 + 0.15 * t) : 0.9, child: content);
      case TabItemAnimation.bounce:
        final s = selected ? (1 + 0.18 * math.sin(t * math.pi)) : 0.92;
        content = Transform.scale(scale: s, child: content);
      case TabItemAnimation.flip:
        content = Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(selected ? (1 - t) * math.pi : 0),
          child: content,
        );
      case TabItemAnimation.rotate:
        break;
      case TabItemAnimation.shift:
      case TabItemAnimation.labelReveal:
      case TabItemAnimation.flashy:
        content = Transform.translate(
          offset: Offset(0, selected ? -6.0 * t : 0),
          child: content,
        );
      case TabItemAnimation.iconMorph:
        content = AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 200),
          child: content,
        );
      case TabItemAnimation.slidingClipped:
        content = ClipRect(
          child: Align(
            alignment: Alignment.center,
            heightFactor: selected ? (0.7 + 0.3 * t) : 0.85,
            child: content,
          ),
        );
      case TabItemAnimation.squeezeStretch:
        content = Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(
            selected ? (1 + 0.12 * math.sin(t * math.pi)) : 1,
            selected ? (1 - 0.08 * math.sin(t * math.pi)) : 1,
            1,
          ),
          child: content,
        );
      case TabItemAnimation.parallax:
        final delta = (index - selectedIndex).toDouble();
        content = Transform.translate(
          offset: Offset(delta * 4 * (1 - progress), 0),
          child: content,
        );
      case TabItemAnimation.pulse:
        content = Transform.scale(
          scale: selected ? (1 + 0.06 * math.sin(progress * math.pi * 2)) : 1,
          child: content,
        );
      case TabItemAnimation.wiggle:
        content = Transform.rotate(
          angle: selected ? 0.08 * math.sin(progress * math.pi * 3) : 0,
          child: content,
        );
    }

    if (label == null) {
      return _wrapRotate(content, t);
    }

    Widget labeled = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        content,
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              label!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: labelColor,
              ),
            ),
          ),
      ],
    );
    return _wrapRotate(labeled, t);
  }

  Widget _wrapRotate(Widget child, double t) {
    if (animation != TabItemAnimation.rotate) return child;
    // Selected: 0 → π → 0 (full 180° then settle). Unselected stays upright.
    final angle = selected ? math.sin(t * math.pi) * math.pi : 0.0;
    return Transform.rotate(
      angle: angle,
      child: child,
    );
  }
}
