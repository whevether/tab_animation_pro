import 'package:flutter/widgets.dart';

import 'tab_media_scope.dart';

/// Builds a custom graphic from [TabMediaState] (host supplies Lottie/GIF/etc.).
typedef TabGraphicBuilder = Widget Function(
  BuildContext context,
  TabMediaState state,
);

/// Icon / image / externally supplied widget for a tab.
@immutable
class TabGraphic {
  const TabGraphic._({
    this.iconData,
    this.image,
    this.child,
    this.builder,
    this.size = 24,
    this.color,
  });

  factory TabGraphic.icon(
    IconData icon, {
    double size = 24,
    Color? color,
  }) {
    return TabGraphic._(iconData: icon, size: size, color: color);
  }

  factory TabGraphic.image(
    ImageProvider image, {
    double size = 24,
    Color? color,
  }) {
    return TabGraphic._(image: image, size: size, color: color);
  }

  factory TabGraphic.widget(Widget child, {double size = 24}) {
    return TabGraphic._(child: child, size: size);
  }

  factory TabGraphic.builder(TabGraphicBuilder builder, {double size = 24}) {
    return TabGraphic._(builder: builder, size: size);
  }

  final IconData? iconData;
  final ImageProvider? image;
  final Widget? child;
  final TabGraphicBuilder? builder;
  final double size;
  final Color? color;

  Widget build(BuildContext context, TabMediaState state, {Color? tint}) {
    final resolvedColor = tint ?? color;
    if (builder != null) {
      return SizedBox(
        width: size,
        height: size,
        child: builder!(context, state),
      );
    }
    if (child != null) {
      return SizedBox(width: size, height: size, child: child);
    }
    if (image != null) {
      return Image(
        image: image!,
        width: size,
        height: size,
        color: resolvedColor,
        fit: BoxFit.contain,
        gaplessPlayback: true,
      );
    }
    if (iconData != null) {
      return Icon(iconData, size: size, color: resolvedColor);
    }
    return SizedBox(width: size, height: size);
  }
}
