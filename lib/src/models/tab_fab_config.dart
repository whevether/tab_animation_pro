import 'package:flutter/material.dart';

import 'enums.dart';

/// Docked FAB + optional notch. Applies to every [TabBarShape] except
/// `container` / `sCurve` / `sDivider`. `materialNotch` still uses the
/// [animated_bottom_navigation_bar] circular cutout; water-drop and other
/// flat-top bars cut a matching docked notch when [showFab] is true.
@immutable
class TabFabConfig {
  const TabFabConfig({
    this.location = TabFabLocation.center,
    this.smoothness = TabNotchSmoothness.verySmoothEdge,
    this.margin = 8,
    this.size = 56,
    this.icon = Icons.add,
    this.onTap,
    this.animateOnTap = true,
  });

  /// Where the FAB / gap sits: none, center, or end.
  final TabFabLocation location;

  /// Notch shoulder smoothness (`NotchSmoothness`).
  final TabNotchSmoothness smoothness;

  /// Gap between the FAB disk and the notch edge (`notchMargin`, default 8).
  final double margin;

  /// FAB diameter (Material default is 56).
  final double size;

  /// Icon drawn on the FAB.
  final IconData icon;

  /// Called when the FAB is tapped. Tab item taps never run this.
  final VoidCallback? onTap;

  /// When true, tapping the FAB replays the appear animation (scale + notch
  /// grow), matching the reference example’s FAB press.
  final bool animateOnTap;

  bool get showFab => location != TabFabLocation.none;

  double get gapWidth => size + margin * 2;

  TabFabConfig copyWith({
    TabFabLocation? location,
    TabNotchSmoothness? smoothness,
    double? margin,
    double? size,
    IconData? icon,
    VoidCallback? onTap,
    bool? animateOnTap,
  }) {
    return TabFabConfig(
      location: location ?? this.location,
      smoothness: smoothness ?? this.smoothness,
      margin: margin ?? this.margin,
      size: size ?? this.size,
      icon: icon ?? this.icon,
      onTap: onTap ?? this.onTap,
      animateOnTap: animateOnTap ?? this.animateOnTap,
    );
  }
}
