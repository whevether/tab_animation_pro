import 'package:material_ui/material_ui.dart';

import 'tab_media_scope.dart';

/// Builds a custom badge from [TabMediaState].
typedef TabBadgeBuilder = Widget Function(
  BuildContext context,
  TabMediaState state,
);

/// Badge overlay for a tab item.
@immutable
class TabBadge {
  const TabBadge._({
    this.dot = false,
    this.count,
    this.text,
    this.child,
    this.builder,
    this.color,
    this.textColor,
    this.alignment = Alignment.topRight,
    this.offset = const Offset(4, -4),
    this.size,
  });

  factory TabBadge.dot({
    Color? color,
    Alignment alignment = Alignment.topRight,
    Offset offset = const Offset(4, -4),
  }) {
    return TabBadge._(
      dot: true,
      color: color,
      alignment: alignment,
      offset: offset,
      size: const Size(8, 8),
    );
  }

  factory TabBadge.count(
    int count, {
    Color? color,
    Color? textColor,
    Alignment alignment = Alignment.topRight,
    Offset offset = const Offset(4, -4),
  }) {
    return TabBadge._(
      count: count,
      color: color,
      textColor: textColor,
      alignment: alignment,
      offset: offset,
    );
  }

  factory TabBadge.text(
    String text, {
    Color? color,
    Color? textColor,
    Alignment alignment = Alignment.topRight,
    Offset offset = const Offset(4, -4),
  }) {
    return TabBadge._(
      text: text,
      color: color,
      textColor: textColor,
      alignment: alignment,
      offset: offset,
    );
  }

  factory TabBadge.widget(
    Widget child, {
    Alignment alignment = Alignment.topRight,
    Offset offset = const Offset(4, -4),
    Size? size,
  }) {
    return TabBadge._(
      child: child,
      alignment: alignment,
      offset: offset,
      size: size,
    );
  }

  factory TabBadge.builder(
    TabBadgeBuilder builder, {
    Alignment alignment = Alignment.topRight,
    Offset offset = const Offset(4, -4),
    Size? size,
  }) {
    return TabBadge._(
      builder: builder,
      alignment: alignment,
      offset: offset,
      size: size,
    );
  }

  final bool dot;
  final int? count;
  final String? text;
  final Widget? child;
  final TabBadgeBuilder? builder;
  final Color? color;
  final Color? textColor;
  final Alignment alignment;
  final Offset offset;
  final Size? size;

  bool get isVisible {
    if (builder != null || child != null || dot) return true;
    if (count != null) return count! > 0;
    if (text != null) return text!.isNotEmpty;
    return false;
  }

  Widget build(BuildContext context, TabMediaState state) {
    if (builder != null) {
      return builder!(context, state);
    }
    if (child != null) {
      return size == null
          ? child!
          : SizedBox(width: size!.width, height: size!.height, child: child);
    }

    final bg = color ?? const Color(0xFFE53935);
    final fg = textColor ?? Colors.white;

    if (dot) {
      final s = size ?? const Size(8, 8);
      return Container(
        width: s.width,
        height: s.height,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      );
    }

    final label = text ?? (count == null ? null : (count! > 99 ? '99+' : '$count'));
    if (label == null) return const SizedBox.shrink();

    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
      ),
    );
  }
}
