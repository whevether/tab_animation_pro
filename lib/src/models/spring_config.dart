import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';

/// Spring physics for overshoot / liquid style transitions.
@immutable
class TabSpringConfig {
  const TabSpringConfig({
    this.stiffness = 120,
    this.damping = 14,
    this.mass = 1,
  }) : assert(stiffness > 0),
       assert(damping >= 0),
       assert(mass > 0);

  /// Evaluates liquid transitions over the configured animation duration.
  /// Normalize the end point so the selected item always settles exactly.
  double transform(double progress, Duration duration) {
    if (progress <= 0 || progress >= 1 || duration == Duration.zero) {
      return progress.clamp(0.0, 1.0);
    }
    final simulation = SpringSimulation(description, 0, 1, 0);
    final seconds = duration.inMicroseconds / Duration.microsecondsPerSecond;
    final end = simulation.x(seconds);
    if (end.abs() < 0.000001) return progress;
    return simulation.x(progress * seconds) / end;
  }

  final double stiffness;
  final double damping;
  final double mass;

  SpringDescription get description =>
      SpringDescription(mass: mass, stiffness: stiffness, damping: damping);
}
