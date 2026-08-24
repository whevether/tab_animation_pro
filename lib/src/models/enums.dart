/// Position of the tab bar in the host layout.
/// [left] / [right] match [tab_container](https://pub.dev/packages/tab_container) side edges.
enum TabBarPosition {
  bottom,
  top,
  left,
  right,
}

/// Outline geometry of the entire tab bar.
enum TabBarShape {
  fixed,
  rounded,
  squircle,
  floating,
  pill,
  segmented,
  underline,
  convexFixed,
  convexReact,
  concave,
  /// Fixed center circular cutout + docked FAB
  /// ([animated_bottom_navigation_bar](https://pub.dev/packages/animated_bottom_navigation_bar) style).
  materialNotch,
  /// Softer notch + floating disc that follow the selected tab.
  curvedNotch,
  bubble,
  wave,
  waterDrop,
  /// Joined body + protruding selected tab (tab_container style).
  container,
  /// Piano-key tabs with interlocking S-curve side edges; selected key taps down then rests flush.
  sCurve,
  /// Piano keys with S-curve seams drawn as divider strokes.
  sDivider,
  custom,
}

extension TabBarShapeFab on TabBarShape {
  /// Piano-key / container bars do not host a docked FAB.
  bool get supportsDockedFab =>
      this != TabBarShape.container &&
      this != TabBarShape.sCurve &&
      this != TabBarShape.sDivider;

  /// Cut a circular docked notch under the FAB (flat-top bars + water drop).
  bool get cutsFabNotch =>
      this == TabBarShape.materialNotch ||
      this == TabBarShape.fixed ||
      this == TabBarShape.rounded ||
      this == TabBarShape.squircle ||
      this == TabBarShape.floating ||
      this == TabBarShape.pill ||
      this == TabBarShape.segmented ||
      this == TabBarShape.underline ||
      this == TabBarShape.waterDrop ||
      this == TabBarShape.concave;
}

/// FAB placement for bars that [TabBarShapeFab.supportsDockedFab].
enum TabFabLocation {
  /// No FAB.
  none,

  /// Center-docked in the bar (notch + tab gap).
  center,

  /// Outside the bar, top-left corner.
  topLeft,

  /// Outside the bar, top-right corner.
  topRight,

  /// Outside the bar, far left.
  left,

  /// Outside the bar, far right.
  right,
}

extension TabFabLocationLayout on TabFabLocation {
  bool get showFab => this != TabFabLocation.none;

  /// Notch + center gap; only [center].
  bool get isDockedCenter => this == TabFabLocation.center;

  bool get isOutsideTop =>
      this == TabFabLocation.topLeft || this == TabFabLocation.topRight;

  bool get isOutsideSide =>
      this == TabFabLocation.left || this == TabFabLocation.right;
}

/// Notch shoulder curve for [TabBarShape.materialNotch], matching
/// [animated_bottom_navigation_bar] `NotchSmoothness`.
enum TabNotchSmoothness {
  sharpEdge,
  defaultEdge,
  softEdge,
  smoothEdge,
  verySmoothEdge,
}

extension TabNotchSmoothnessCurve on TabNotchSmoothness {
  double get s1 => switch (this) {
        TabNotchSmoothness.sharpEdge => 0.0,
        TabNotchSmoothness.defaultEdge => 15.0,
        TabNotchSmoothness.softEdge => 20.0,
        TabNotchSmoothness.smoothEdge => 30.0,
        TabNotchSmoothness.verySmoothEdge => 40.0,
      };

  double get s2 => switch (this) {
        TabNotchSmoothness.sharpEdge => 0.1,
        TabNotchSmoothness.defaultEdge => 1.0,
        TabNotchSmoothness.softEdge => 5.0,
        TabNotchSmoothness.smoothEdge => 15.0,
        TabNotchSmoothness.verySmoothEdge => 25.0,
      };
}

/// Clip / highlight geometry for a selected tab item.
enum TabItemShape {
  /// No selected-slot highlight (no capsule / ellipse).
  none,
  circle,
  stadium,
  hexagon,
  diamond,
  trapezoid,
  parallelogram,
  leaf,
  custom,
}

/// Surface treatment (not geometry).
enum TabBarSurface {
  solid,
  gradient,

  /// Liquid frosted glass: live [BackdropFilter] blur, Rec. 709 vibrancy,
  /// thin tint, and a specular rim. Put content behind the bar
  /// (`Scaffold.extendBody`) so the frost has something to sample.
  glass,
  neumorphic,
}

/// How the selection indicator moves.
enum TabIndicatorStyle {
  none,
  slidingPill,
  slideLine,
  worm,
  snake,
  topSweep,
  bubblePop,
  dot,
  floatingDot,
  inkDrop,
  gradientSpotlight,
  waterDrop,
  starTwinkle,
  moonTwinkle,
  liquidBlob,
  liquidMorph,
  chipExpand,
  custom,
}

/// How icon / label content animates.
enum TabItemAnimation {
  none,
  fade,
  scale,
  bounce,
  flip,
  rotate,
  shift,
  labelReveal,
  flashy,
  iconMorph,
  slidingClipped,
  squeezeStretch,
  parallax,
  pulse,
  wiggle,
  colorTween,
  custom,
}

/// Press / switch feedback.
enum TabFeedbackAnimation {
  none,
  ripple,
  glow,
  neonPulse,
  elasticPop,
  badgePop,
  haptic,
  starTwinkle,
  /// Crescent moons twinkle around the selected icon and label.
  moonTwinkle,
}

/// Motion coupled to the bar path.
enum TabBarMotion {
  none,
  followNotch,
  waveTravel,
  blobFollow,
  minimizeOnScroll,
}

/// One-shot preset mapping indicator + item animations.
enum TabAnimationStyle {
  none,
  fade,
  scale,
  slideIndicator,
  bounce,
  flip,
  rotate,
  liquidMorph,
  labelReveal,
  shift,
  snake,
  worm,
  waterDrop,
  starTwinkle,
  moonTwinkle,
  chipExpand,
  flashy,
  bubblePop,
  inkDrop,
  floatingDot,
  spotlight,
  squeeze,
  neonPulse,
  iconMorph,
  slidingClipped,
  parallax,
}

/// 3D transform styles (aligned with swiper_view_pro naming).
enum Tab3DStyle {
  cube,
  threeD,
  flip,
  coverflow,
  carousel,
  cards,
  rotate,
}
