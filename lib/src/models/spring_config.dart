import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';

/// Spring physics for overshoot / liquid style transitions.
@immutable
class TabSpringConfig {
  const TabSpringConfig({
    this.stiffness = 120,
    this.damping = 14,
    this.mass = 1,
  });

  final double stiffness;
  final double damping;
  final double mass;

  SpringDescription get description => SpringDescription(
        mass: mass,
        stiffness: stiffness,
        damping: damping,
      );
}
