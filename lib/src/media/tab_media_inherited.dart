import 'package:flutter/widgets.dart';

import 'tab_media_scope.dart';

/// Provides [TabMediaState] to descendant host-built icons / badges.
class TabMediaScope extends InheritedWidget {
  const TabMediaScope({
    super.key,
    required this.state,
    required super.child,
  });

  final TabMediaState state;

  static TabMediaState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<TabMediaScope>();
    assert(scope != null, 'TabMediaScope not found in context');
    return scope!.state;
  }

  static TabMediaState? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TabMediaScope>()?.state;
  }

  @override
  bool updateShouldNotify(TabMediaScope oldWidget) => state != oldWidget.state;
}
