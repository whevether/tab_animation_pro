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
  /// Fixed center circular cradle (Material BottomAppBar style).
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
