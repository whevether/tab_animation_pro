import 'package:flutter/foundation.dart';

/// Controls tab index programmatically.
class TabAnimationController extends ChangeNotifier {
  TabAnimationController({int initialIndex = 0}) : _index = initialIndex;

  int _index;
  int get index => _index;

  void jumpTo(int index) {
    if (_index == index) return;
    _index = index;
    notifyListeners();
  }

  void animateTo(int index) {
    // Animation is owned by the bar; this notifies a desired target.
    jumpTo(index);
  }

  void next({required int itemCount}) {
    if (itemCount <= 0) return;
    jumpTo((_index + 1) % itemCount);
  }

  void previous({required int itemCount}) {
    if (itemCount <= 0) return;
    jumpTo((_index - 1 + itemCount) % itemCount);
  }
}
