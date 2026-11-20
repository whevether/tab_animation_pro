import 'package:flutter/foundation.dart';

/// Controls tab index programmatically.
class TabAnimationController extends ChangeNotifier {
  TabAnimationController({int initialIndex = 0}) : _index = initialIndex;

  int _index;
  bool _animate = true;
  int get index => _index;

  /// Whether the last change should be animated by the bar.
  bool get animate => _animate;

  /// Selects [index] immediately, without a transition animation.
  void jumpTo(int index) => _set(index, animate: false);

  /// Selects [index] with the bar's transition animation.
  void animateTo(int index) => _set(index, animate: true);

  void _set(int index, {required bool animate}) {
    if (_index == index) return;
    _index = index;
    _animate = animate;
    notifyListeners();
  }

  void next({required int itemCount}) {
    if (itemCount <= 0) return;
    animateTo((_index + 1) % itemCount);
  }

  void previous({required int itemCount}) {
    if (itemCount <= 0) return;
    animateTo((_index - 1 + itemCount) % itemCount);
  }
}
