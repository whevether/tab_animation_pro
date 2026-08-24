import '../models/enums.dart';

/// Resolves a [TabAnimationStyle] preset into layered animation enums.
class TabAnimationPreset {
  const TabAnimationPreset({
    required this.indicator,
    required this.item,
    this.feedback = TabFeedbackAnimation.none,
    this.barMotion = TabBarMotion.none,
  });

  final TabIndicatorStyle indicator;
  final TabItemAnimation item;
  final TabFeedbackAnimation feedback;
  final TabBarMotion barMotion;

  static TabAnimationPreset resolve(TabAnimationStyle style) {
    switch (style) {
      case TabAnimationStyle.none:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.none,
          item: TabItemAnimation.none,
        );
      case TabAnimationStyle.fade:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.none,
          item: TabItemAnimation.fade,
        );
      case TabAnimationStyle.scale:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.none,
          item: TabItemAnimation.scale,
        );
      case TabAnimationStyle.slideIndicator:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.slidingPill,
          item: TabItemAnimation.colorTween,
        );
      case TabAnimationStyle.bounce:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.bubblePop,
          item: TabItemAnimation.bounce,
        );
      case TabAnimationStyle.flip:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.none,
          item: TabItemAnimation.flip,
        );
      case TabAnimationStyle.rotate:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.none,
          item: TabItemAnimation.rotate,
        );
      case TabAnimationStyle.liquidMorph:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.liquidMorph,
          item: TabItemAnimation.scale,
          barMotion: TabBarMotion.blobFollow,
        );
      case TabAnimationStyle.labelReveal:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.none,
          item: TabItemAnimation.labelReveal,
        );
      case TabAnimationStyle.shift:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.none,
          item: TabItemAnimation.shift,
        );
      case TabAnimationStyle.snake:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.snake,
          item: TabItemAnimation.scale,
        );
      case TabAnimationStyle.worm:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.worm,
          item: TabItemAnimation.bounce,
        );
      case TabAnimationStyle.waterDrop:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.waterDrop,
          item: TabItemAnimation.none,
        );
      case TabAnimationStyle.starTwinkle:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.starTwinkle,
          item: TabItemAnimation.pulse,
          feedback: TabFeedbackAnimation.starTwinkle,
        );
      case TabAnimationStyle.moonTwinkle:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.moonTwinkle,
          item: TabItemAnimation.pulse,
          feedback: TabFeedbackAnimation.moonTwinkle,
        );
      case TabAnimationStyle.chipExpand:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.chipExpand,
          item: TabItemAnimation.labelReveal,
        );
      case TabAnimationStyle.flashy:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.none,
          item: TabItemAnimation.flashy,
        );
      case TabAnimationStyle.bubblePop:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.bubblePop,
          item: TabItemAnimation.bounce,
        );
      case TabAnimationStyle.inkDrop:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.inkDrop,
          item: TabItemAnimation.scale,
        );
      case TabAnimationStyle.floatingDot:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.floatingDot,
          item: TabItemAnimation.bounce,
        );
      case TabAnimationStyle.spotlight:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.gradientSpotlight,
          item: TabItemAnimation.fade,
        );
      case TabAnimationStyle.squeeze:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.slidingPill,
          item: TabItemAnimation.squeezeStretch,
        );
      case TabAnimationStyle.neonPulse:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.slidingPill,
          item: TabItemAnimation.pulse,
          feedback: TabFeedbackAnimation.neonPulse,
        );
      case TabAnimationStyle.iconMorph:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.none,
          item: TabItemAnimation.iconMorph,
        );
      case TabAnimationStyle.slidingClipped:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.none,
          item: TabItemAnimation.slidingClipped,
        );
      case TabAnimationStyle.parallax:
        return const TabAnimationPreset(
          indicator: TabIndicatorStyle.slidingPill,
          item: TabItemAnimation.parallax,
        );
    }
  }
}
