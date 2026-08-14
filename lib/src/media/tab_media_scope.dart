import 'package:flutter/foundation.dart';

/// Selection / motion context exposed to host-built icons and badges.
@immutable
class TabMediaState {
  const TabMediaState({
    required this.index,
    required this.isSelected,
    required this.reduceMotion,
    this.animation = 1.0,
  });

  final int index;
  final bool isSelected;
  final bool reduceMotion;

  /// Progress of the tab transition for this item, typically 0–1.
  final double animation;

  @override
  bool operator ==(Object other) {
    return other is TabMediaState &&
        other.index == index &&
        other.isSelected == isSelected &&
        other.reduceMotion == reduceMotion &&
        other.animation == animation;
  }

  @override
  int get hashCode => Object.hash(index, isSelected, reduceMotion, animation);
}
