import 'package:material_ui/material_ui.dart';

/// Host-supplied palette for [TabAnimationPro].
///
/// Unset fields fall back to [ThemeData.colorScheme] (or a related field
/// documented on each property).
@immutable
class TabColors {
  const TabColors({
    this.background,
    this.active,
    this.inactive,
    this.indicator,
    this.gradient,
    this.fab,
    this.fabIcon,
    this.pressed,
    this.labelActive,
    this.labelInactive,
    this.divider,
    this.shadow,
    this.ripple,
    this.glow,
    this.star,
    this.pianoSeam,
  });

  /// Bar fill. Falls back to [ColorScheme.surface].
  final Color? background;

  /// Selected icon / water-drop filled icon. Falls back to [ColorScheme.primary].
  final Color? active;

  /// Unselected icon. Falls back to [ColorScheme.onSurfaceVariant].
  final Color? inactive;

  /// Indicator, hanging drip, falling bead, curved-notch dot.
  /// Falls back to [active].
  final Color? indicator;

  /// Optional bar gradient (overrides a flat [background] fill when set).
  final Gradient? gradient;

  /// Material-notch center disc. Falls back to [active].
  final Color? fab;

  /// Icon on the material-notch disc. Falls back to [ColorScheme.onPrimary].
  final Color? fabIcon;

  /// Pressed piano key / selected-key fill. Falls back to lerp(background, indicator).
  final Color? pressed;

  /// Selected label. Falls back to [active].
  final Color? labelActive;

  /// Unselected label. Falls back to [inactive].
  final Color? labelInactive;

  /// S-divider strokes. Falls back to [inactive] at 45% opacity.
  final Color? divider;

  /// Bar / disc drop shadow. Falls back to black 26%.
  final Color? shadow;

  /// InkWell splash. Falls back to [active] at 20% opacity.
  final Color? ripple;

  /// Glow / neon feedback. Falls back to [active].
  final Color? glow;

  /// Star-twinkle sparkles. Falls back to [active].
  final Color? star;

  /// Piano-key seam stroke. Falls back to black at low opacity.
  final Color? pianoSeam;

  TabColors copyWith({
    Color? background,
    Color? active,
    Color? inactive,
    Color? indicator,
    Gradient? gradient,
    Color? fab,
    Color? fabIcon,
    Color? pressed,
    Color? labelActive,
    Color? labelInactive,
    Color? divider,
    Color? shadow,
    Color? ripple,
    Color? glow,
    Color? star,
    Color? pianoSeam,
  }) {
    return TabColors(
      background: background ?? this.background,
      active: active ?? this.active,
      inactive: inactive ?? this.inactive,
      indicator: indicator ?? this.indicator,
      gradient: gradient ?? this.gradient,
      fab: fab ?? this.fab,
      fabIcon: fabIcon ?? this.fabIcon,
      pressed: pressed ?? this.pressed,
      labelActive: labelActive ?? this.labelActive,
      labelInactive: labelInactive ?? this.labelInactive,
      divider: divider ?? this.divider,
      shadow: shadow ?? this.shadow,
      ripple: ripple ?? this.ripple,
      glow: glow ?? this.glow,
      star: star ?? this.star,
      pianoSeam: pianoSeam ?? this.pianoSeam,
    );
  }
}

/// Resolved, non-null colors after theme fallback.
@immutable
class ResolvedTabColors {
  const ResolvedTabColors({
    required this.background,
    required this.active,
    required this.inactive,
    required this.indicator,
    required this.fab,
    required this.fabIcon,
    required this.pressed,
    required this.labelActive,
    required this.labelInactive,
    required this.divider,
    required this.shadow,
    required this.ripple,
    required this.glow,
    required this.star,
    required this.pianoSeam,
    this.gradient,
  });

  final Color background;
  final Color active;
  final Color inactive;
  final Color indicator;
  final Color fab;
  final Color fabIcon;
  final Color pressed;
  final Color labelActive;
  final Color labelInactive;
  final Color divider;
  final Color shadow;
  final Color ripple;
  final Color glow;
  final Color star;
  final Color pianoSeam;
  final Gradient? gradient;

  static ResolvedTabColors resolve(
    BuildContext context, {
    TabColors colors = const TabColors(),
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
    Color? indicatorColor,
    Gradient? gradient,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? colors.background ?? scheme.surface;
    final active = activeColor ?? colors.active ?? scheme.primary;
    final inactive =
        inactiveColor ?? colors.inactive ?? scheme.onSurfaceVariant;
    final indicator = indicatorColor ?? colors.indicator ?? active;
    final pressed = colors.pressed ??
        Color.lerp(bg, indicator, 0.55) ??
        indicator;
    return ResolvedTabColors(
      background: bg,
      active: active,
      inactive: inactive,
      indicator: indicator,
      fab: colors.fab ?? active,
      fabIcon: colors.fabIcon ?? scheme.onPrimary,
      pressed: pressed,
      labelActive: colors.labelActive ?? active,
      labelInactive: colors.labelInactive ?? inactive,
      divider: colors.divider ?? inactive.withValues(alpha: 0.45),
      shadow: colors.shadow ?? const Color(0x42000000),
      ripple: colors.ripple ?? active.withValues(alpha: 0.2),
      glow: colors.glow ?? active,
      star: colors.star ?? active,
      pianoSeam: colors.pianoSeam ?? const Color(0x14000000),
      gradient: gradient ?? colors.gradient,
    );
  }
}
