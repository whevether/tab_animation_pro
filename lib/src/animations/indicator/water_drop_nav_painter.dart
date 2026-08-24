import 'dart:ui' show lerpDouble;

import 'package:material_ui/material_ui.dart';

import '../../layout/tab_slot_geometry.dart';

/// Hanging drip silhouette from
/// https://pub.dev/packages/water_drop_nav_bar `WaterDropPainter`.
Path buildWaterDropDripPath(Size size) {
  final path = Path();
  path.cubicTo(
    size.width * 0.239841,
    size.height * 0.06489535,
    size.width * 0.285956,
    size.height * 0.4886860,
    size.width * 0.42016,
    size.height * 0.8271512,
  );
  path.cubicTo(
    size.width * 0.467771,
    size.height * 0.9466628,
    size.width * 0.530574,
    size.height * 0.9472209,
    size.width * 0.578344,
    size.height * 0.8285814,
  );
  path.cubicTo(
    size.width * 0.7185669,
    size.height * 0.4786744,
    size.width * 0.757325,
    size.height * 0.06629070,
    size.width * 0.999682,
    0,
  );
  path.lineTo(0, 0);
  path.close();
  return path;
}

double _interval(double t, double begin, double end) {
  if (end <= begin) return t >= end ? 1 : 0;
  return ((t - begin) / (end - begin)).clamp(0.0, 1.0);
}

/// Running + falling drop matching water_drop_nav_bar `BuildRunningDrop`.
///
/// [progress] must be the raw 0–1 controller value (linear, ~800ms).
class WaterDropNavPainter extends CustomPainter {
  WaterDropNavPainter({
    required this.selectedIndex,
    required this.previousIndex,
    required this.itemCount,
    required this.progress,
    required this.color,
    this.slots,
    this.clipPath,
  });

  final int selectedIndex;
  final int previousIndex;
  final int itemCount;
  final double progress;
  final Color color;
  final TabSlotGeometry? slots;

  /// Bar outline in this painter's coordinates. Clips the flat-top drip so it
  /// cannot spill into a docked-FAB notch (soft/smooth/verySmooth shoulders).
  final Path? clipPath;

  @override
  void paint(Canvas canvas, Size size) {
    final geometry = slots ??
        TabSlotGeometry.of(width: size.width, itemCount: itemCount);
    final itemW = geometry.slotWidth;
    final t = progress.clamp(0.0, 1.0);

    final slide = Curves.linear.transform(_interval(t, 0.0, 0.35));
    final left = lerpDouble(
      geometry.left(previousIndex),
      geometry.left(selectedIndex),
      slide,
    )!;

    late final double dripW;
    late final double dripH;
    if (t <= 0.45) {
      final m = _interval(t, 0.3, 0.45);
      dripW = lerpDouble(72, 56, m)!;
      dripH = lerpDouble(16, 24, m)!;
    } else {
      final m = _interval(t, 0.45, 0.60);
      dripW = lerpDouble(56, 72, m)!;
      dripH = lerpDouble(24, 16, m)!;
    }

    canvas.save();
    if (clipPath != null) {
      canvas.clipPath(clipPath!);
    }

    // Hanging drip stays on the selected tab at rest (progress == 1).
    canvas.save();
    canvas.translate(left + (itemW - dripW) / 2, 0);
    canvas.drawPath(
      buildWaterDropDripPath(Size(dripW, dripH)),
      Paint()..color = color,
    );
    canvas.restore();

    // Falling bead: 0.40–0.70, disappears after 0.65 (lands on icon).
    if (t >= 0.40 && t <= 0.65) {
      final fall = _interval(t, 0.40, 0.70);
      final y = lerpDouble(5.0, 40.0, fall)!;
      canvas.drawCircle(
        Offset(left + itemW / 2, y),
        5,
        Paint()..color = color,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant WaterDropNavPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.previousIndex != previousIndex ||
        oldDelegate.color != color ||
        oldDelegate.itemCount != itemCount ||
        oldDelegate.slots != slots ||
        oldDelegate.clipPath != clipPath;
  }
}
