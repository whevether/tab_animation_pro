import 'package:flutter/widgets.dart';

import '../media/tab_badge.dart';
import '../media/tab_graphic.dart';

/// A single tab destination.
@immutable
class TabItem {
  const TabItem({
    required this.icon,
    this.activeIcon,
    this.label,
    this.badge,
    this.semanticLabel,
  });

  /// Inactive (or default) graphic.
  final TabGraphic icon;

  /// Optional graphic shown when selected. Falls back to [icon].
  final TabGraphic? activeIcon;

  /// Optional text label under / beside the icon.
  final String? label;

  /// Optional badge overlay.
  final TabBadge? badge;

  /// Accessibility label; defaults to [label].
  final String? semanticLabel;

  String get resolvedSemanticLabel => semanticLabel ?? label ?? 'Tab';
}
