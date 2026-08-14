import 'dart:math' as math;

import '../models/enums.dart';

/// Horizontal slot layout when a docked FAB inserts a gap between tabs.
///
/// Center FAB sits in a gap before item `itemCount ~/ 2` (same as
/// [animated_bottom_navigation_bar]). End FAB sits after the last tab.
class TabSlotGeometry {
  const TabSlotGeometry({
    required this.starts,
    required this.slotWidth,
    required this.barWidth,
    required this.gapWidth,
    required this.fabLocation,
  });

  factory TabSlotGeometry.of({
    required double width,
    required int itemCount,
    TabFabLocation location = TabFabLocation.none,
    double gapWidth = 0,
  }) {
    final n = math.max(itemCount, 1);
    final showGap = location != TabFabLocation.none && gapWidth > 0;
    final tabW = showGap ? (width - gapWidth) / n : width / n;
    final starts = List<double>.filled(n, 0);
    var x = 0.0;
    final insertAt = showGap && location == TabFabLocation.center ? n ~/ 2 : -1;
    for (var i = 0; i < n; i++) {
      if (i == insertAt) x += gapWidth;
      starts[i] = x;
      x += tabW;
    }
    return TabSlotGeometry(
      starts: starts,
      slotWidth: tabW,
      barWidth: width,
      gapWidth: showGap ? gapWidth : 0,
      fabLocation: showGap ? location : TabFabLocation.none,
    );
  }

  final List<double> starts;
  final double slotWidth;
  final double barWidth;
  final double gapWidth;
  final TabFabLocation fabLocation;

  int get itemCount => starts.length;

  double left(int index) {
    if (starts.isEmpty) return 0;
    return starts[index.clamp(0, starts.length - 1)];
  }

  double centerX(int index) => left(index) + slotWidth / 2;

  double get fabCenterX {
    switch (fabLocation) {
      case TabFabLocation.none:
        return barWidth / 2;
      case TabFabLocation.center:
        if (starts.isEmpty) return barWidth / 2;
        return left(itemCount ~/ 2) - gapWidth / 2;
      case TabFabLocation.end:
        return barWidth - gapWidth / 2;
    }
  }
}
