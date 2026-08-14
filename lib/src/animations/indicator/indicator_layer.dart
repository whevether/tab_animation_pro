import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../layout/tab_slot_geometry.dart';
import '../../models/enums.dart';
import '../../shapes/bar_shapes.dart';
import 'water_drop_nav_painter.dart';

/// Draws the selection indicator for [TabIndicatorStyle].
class TabIndicatorLayer extends StatelessWidget {
  const TabIndicatorLayer({
    super.key,
    required this.animation,
    required this.selectedIndex,
    required this.previousIndex,
    required this.itemCount,
    required this.progress,
    required this.color,
    required this.itemShape,
    this.slots,
    this.clipPath,
    this.customPainter,
  });

  final TabIndicatorStyle animation;
  final int selectedIndex;
  final int previousIndex;
  final int itemCount;
  final double progress;
  final Color color;
  final TabItemShape itemShape;
  final TabSlotGeometry? slots;
  final Path? clipPath;
  final CustomPainter? customPainter;

  @override
  Widget build(BuildContext context) {
    if (animation == TabIndicatorStyle.none) {
      return const SizedBox.expand();
    }
    return CustomPaint(
      painter: customPainter ??
          _IndicatorPainter(
            animation: animation,
            selectedIndex: selectedIndex,
            previousIndex: previousIndex,
            itemCount: itemCount,
            progress: progress,
            color: color,
            itemShape: itemShape,
            slots: slots,
            clipPath: clipPath,
          ),
      size: Size.infinite,
    );
  }
}

class _IndicatorPainter extends CustomPainter {
  _IndicatorPainter({
    required this.animation,
    required this.selectedIndex,
    required this.previousIndex,
    required this.itemCount,
    required this.progress,
    required this.color,
    required this.itemShape,
    this.slots,
    this.clipPath,
  });

  final TabIndicatorStyle animation;
  final int selectedIndex;
  final int previousIndex;
  final int itemCount;
  final double progress;
  final Color color;
  final TabItemShape itemShape;
  final TabSlotGeometry? slots;
  final Path? clipPath;

  @override
  void paint(Canvas canvas, Size size) {
    if (clipPath != null) {
      canvas.save();
      canvas.clipPath(clipPath!);
    }
    try {
      _paintIndicator(canvas, size);
    } finally {
      if (clipPath != null) {
        canvas.restore();
      }
    }
  }

  void _paintIndicator(Canvas canvas, Size size) {
    final geometry = slots ??
        TabSlotGeometry.of(width: size.width, itemCount: itemCount);
    final itemW = geometry.slotWidth;
    final from = geometry.centerX(previousIndex);
    final to = geometry.centerX(selectedIndex);
    final cx = lerpDouble(from, to, progress)!;
    final cy = size.height / 2;
    final paint = Paint()..color = color.withValues(alpha: 0.22);

    switch (animation) {
      case TabIndicatorStyle.none:
      case TabIndicatorStyle.custom:
        return;
      case TabIndicatorStyle.slidingPill:
      case TabIndicatorStyle.liquidMorph:
      case TabIndicatorStyle.chipExpand:
      case TabIndicatorStyle.liquidBlob:
        if (itemShape == TabItemShape.none) return;
        final widthFactor =
            animation == TabIndicatorStyle.chipExpand ? 0.92 : 0.72;
        final rect = Rect.fromCenter(
          center: Offset(cx, cy),
          width: itemW * widthFactor,
          height: size.height * 0.62,
        );
        canvas.drawPath(buildItemShapePath(itemShape, rect), paint);
      case TabIndicatorStyle.slideLine:
      case TabIndicatorStyle.worm:
      case TabIndicatorStyle.snake:
        final stretch = animation == TabIndicatorStyle.worm ||
                animation == TabIndicatorStyle.snake
            ? (1 - (progress - 0.5).abs() * 2) * itemW * 0.35
            : 0.0;
        final lineW = itemW * 0.35 + stretch;
        final y = size.height - 6;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(cx, y), width: lineW, height: 3),
            const Radius.circular(2),
          ),
          Paint()..color = color,
        );
      case TabIndicatorStyle.topSweep:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(cx, 3),
              width: itemW * 0.45,
              height: 3,
            ),
            const Radius.circular(2),
          ),
          Paint()..color = color,
        );
      case TabIndicatorStyle.bubblePop:
      case TabIndicatorStyle.inkDrop:
        final t = Curves.easeOutBack.transform(progress.clamp(0.0, 1.0));
        final r = (animation == TabIndicatorStyle.inkDrop ? 16.0 : 14.0) * t;
        canvas.drawCircle(Offset(cx, cy - 2), r, paint);
      case TabIndicatorStyle.waterDrop:
        // water_drop_nav_bar-style hanging drip + falling bead.
        WaterDropNavPainter(
          selectedIndex: selectedIndex,
          previousIndex: previousIndex,
          itemCount: itemCount,
          progress: progress,
          color: color,
          slots: geometry,
        ).paint(canvas, size);
      case TabIndicatorStyle.starTwinkle:
        // Soft spotlight under stars; stars themselves are feedback overlay.
        final t = Curves.easeOutBack.transform(progress.clamp(0.0, 1.0));
        canvas.drawCircle(
          Offset(cx, cy - 4),
          10 * t,
          Paint()..color = color.withValues(alpha: 0.18),
        );
      case TabIndicatorStyle.dot:
        canvas.drawCircle(
          Offset(cx, size.height - 8),
          3.5,
          Paint()..color = color,
        );
      case TabIndicatorStyle.floatingDot:
        final arcY = cy - 18 * math.sin(progress * math.pi);
        final squash = 1 + 0.35 * math.sin(progress * math.pi);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cx, arcY),
            width: 8 * squash,
            height: 8 / squash,
          ),
          Paint()..color = color,
        );
      case TabIndicatorStyle.gradientSpotlight:
        final rect = Rect.fromCenter(
          center: Offset(cx, cy),
          width: itemW * 0.9,
          height: size.height,
        );
        paint.shader = RadialGradient(
          colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0)],
        ).createShader(rect);
        canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _IndicatorPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.previousIndex != previousIndex ||
        oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.itemShape != itemShape ||
        oldDelegate.slots != slots ||
        oldDelegate.clipPath != clipPath;
  }
}

