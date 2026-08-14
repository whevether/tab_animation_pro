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
  /// Crescent moon cut into the bar (inward / 往里).
  moonIn,
  /// Crescent moon bulging out of the bar (outward / 往外).
  moonOut,
  /// Joined body + protruding selected tab (tab_container style).
  container,
  /// Piano-key tabs with interlocking S-curve side edges; selected key taps down then rests flush.
  sCurve,
  /// Piano keys with S-curve seams drawn as divider strokes.
  sDivider,
  custom,
}

/// Docked FAB slot for [TabBarShape.materialNotch], matching
/// [animated_bottom_navigation_bar] `GapLocation`.
enum TabFabLocation {
  /// No FAB and no notch (rounded bar only).
  none,
  /// Center-docked FAB (`FloatingActionButtonLocation.centerDocked`).
  center,
  /// End-docked FAB (`FloatingActionButtonLocation.endDocked`).
  end,
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
