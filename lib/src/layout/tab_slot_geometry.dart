import 'dart:math' as math;

import '../models/enums.dart';

/// Tab slots along the main axis. Docked FAB gaps stay at the bar's center.
/// Odd counts divide each half between its tabs; [widthAt] gives each extent.
class TabSlotGeometry {
  const TabSlotGeometry({
    required this.starts,
    required this.slotWidth,
    required this.barWidth,
    required this.gapWidth,
    required this.fabLocation,
    this.widths,
  });

  factory TabSlotGeometry.of({
    required double width,
    required int itemCount,
    TabFabLocation location = TabFabLocation.none,
    double gapWidth = 0,
    bool reversed = false,
  }) {
    final w = width.isFinite ? math.max(0.0, width) : 0.0;
    final n = math.max(itemCount, 1);
    final gap = location.isDockedCenter && gapWidth.isFinite
        ? gapWidth.clamp(0.0, w)
        : 0.0;
    final average = (w - gap) / n;
    final starts = <double>[];
    final widths = <double>[];
    final split = n ~/ 2;
    final half = (w - gap) / 2;
    for (var i = 0; i < n; i++) {
      final extent = gap == 0
          ? average
          : half / (i < split ? split : n - split);
      final start = gap == 0
          ? i * extent
          : (i < split ? i * extent : half + gap + (i - split) * extent);
      starts.add(reversed ? w - start - extent : start);
      widths.add(extent);
    }
    return TabSlotGeometry(
      starts: List.unmodifiable(starts),
      widths: List.unmodifiable(widths),
      slotWidth: average,
      barWidth: w,
      gapWidth: gap,
      fabLocation: gap > 0 ? location : TabFabLocation.none,
    );
  }

  final List<double> starts;

  /// Average slot width; use [widthAt] for an individual slot.
  final double slotWidth;
  final List<double>? widths;
  final double barWidth;
  final double gapWidth;
  final TabFabLocation fabLocation;

  int get itemCount => starts.length;
  double left(int index) =>
      starts.isEmpty ? 0 : starts[index.clamp(0, starts.length - 1)];
  double widthAt(int index) => widths == null || widths!.isEmpty
      ? slotWidth
      : widths![index.clamp(0, widths!.length - 1)];
  double centerX(int index) => left(index) + widthAt(index) / 2;
  double get fabCenterX => barWidth / 2;
}
