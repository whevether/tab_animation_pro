import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'animations/feedback/star_twinkle.dart';
import 'animations/indicator/indicator_layer.dart';
import 'animations/indicator/water_drop_nav_painter.dart';
import 'animations/item/item_motion.dart';
import 'animations/item/water_drop_icon_reveal.dart';
import 'animations/preset.dart';
import 'controller.dart';
import 'effects/tab_3d.dart';
import 'media/tab_media_inherited.dart';
import 'media/tab_media_scope.dart';
import 'models/enums.dart';
import 'models/spring_config.dart';
import 'models/tab_colors.dart';
import 'models/tab_item.dart';
import 'shapes/bar_shapes.dart';
import 'shapes/piano_keys_painter.dart';
import 'surfaces/tab_bar_surface.dart';

/// Animated multi-shape tab bar with optional 3D and externally supplied media.
class TabAnimationPro extends StatefulWidget {
  const TabAnimationPro({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.controller,
    this.shape = TabBarShape.fixed,
    this.itemShape = TabItemShape.none,
    this.surface = TabBarSurface.solid,
    this.animation,
    this.indicatorAnimation,
    this.itemAnimation,
    this.feedbackAnimation,
    this.barMotion,
    this.enable3D = false,
    this.threeDStyle = Tab3DStyle.flip,
    this.perspective = 0.0008,
    this.spring = const TabSpringConfig(),
    this.respectReduceMotion = true,
    this.enableDragSelect = false,
    this.position = TabBarPosition.bottom,
    this.height = 64,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
    this.colors = const TabColors(),
    this.gradient,
    this.elevation = 8,
    this.cornerRadius = 16,
    this.tabExtent,
    this.tabCornerRadius,
    this.margin = EdgeInsets.zero,
    this.animationDuration = const Duration(milliseconds: 360),
    this.animationCurve = Curves.easeOutCubic,
    this.showLabels = true,
    this.customBarPath,
    this.safeArea = true,
  });

  final List<TabItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final TabAnimationController? controller;

  final TabBarShape shape;
  final TabItemShape itemShape;
  final TabBarSurface surface;

  /// Convenience preset; overridden by explicit layered animation fields.
  final TabAnimationStyle? animation;
  final TabIndicatorStyle? indicatorAnimation;
  final TabItemAnimation? itemAnimation;
  final TabFeedbackAnimation? feedbackAnimation;
  final TabBarMotion? barMotion;

  final bool enable3D;
  final Tab3DStyle threeDStyle;
  final double perspective;
  final TabSpringConfig spring;
  final bool respectReduceMotion;
  final bool enableDragSelect;

  final TabBarPosition position;
  final double height;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  /// Color of the selection indicator. For [TabBarShape.waterDrop] /
  /// [TabIndicatorStyle.waterDrop] this is the hanging drip and falling bead
  /// (falls back to [activeColor]).
  final Color? indicatorColor;

  /// Full palette. Individual [backgroundColor] / [activeColor] /
  /// [inactiveColor] / [indicatorColor] / [gradient] override matching fields.
  final TabColors colors;

  final Gradient? gradient;
  final double elevation;
  final double cornerRadius;

  /// Height of the protruding tab strip for [TabBarShape.container]
  /// (tab_container `tabExtent`). Defaults to ~42% of [height].
  final double? tabExtent;

  /// Corner radius of the protruding tab for [TabBarShape.container]
  /// (tab_container `tabBorderRadius`). Defaults to [cornerRadius].
  final double? tabCornerRadius;

  final EdgeInsetsGeometry margin;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showLabels;
  final TabBarPathBuilder? customBarPath;
  final bool safeArea;

  @override
  State<TabAnimationPro> createState() => _TabAnimationProState();
}

class _TabAnimationProState extends State<TabAnimationPro>
    with TickerProviderStateMixin {
  late int _index;
  late int _previousIndex;
  late AnimationController _controller;
  late AnimationController _sparkle;
  late Animation<double> _progress;
  bool _minimized = false;

  @override
  void initState() {
    super.initState();
    _index = widget.controller?.index ?? widget.currentIndex;
    _previousIndex = _index;
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _sparkle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _progress = CurvedAnimation(parent: _controller, curve: widget.animationCurve);
    _controller.value = 1;
    widget.controller?.addListener(_onController);
  }

  @override
  void didUpdateWidget(covariant TabAnimationPro oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onController);
      widget.controller?.addListener(_onController);
    }
    if (widget.controller == null && widget.currentIndex != _index) {
      _animateTo(widget.currentIndex);
    }
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onController);
    _controller.dispose();
    _sparkle.dispose();
    super.dispose();
  }

  void _onController() {
    final next = widget.controller!.index;
    if (next != _index) _animateTo(next);
  }

  TabAnimationPreset get _preset {
    final base = widget.animation != null
        ? TabAnimationPreset.resolve(widget.animation!)
        : const TabAnimationPreset(
            indicator: TabIndicatorStyle.slidingPill,
            item: TabItemAnimation.colorTween,
          );
    return TabAnimationPreset(
      indicator: widget.indicatorAnimation ?? base.indicator,
      item: widget.itemAnimation ?? base.item,
      feedback: widget.feedbackAnimation ?? base.feedback,
      barMotion: widget.barMotion ?? base.barMotion,
    );
  }

  void _animateTo(int index) {
    if (index < 0 || index >= widget.items.length || index == _index) return;
    setState(() {
      _previousIndex = _index;
      _index = index;
    });
    _controller.forward(from: 0);
  }

  void _onTap(int index) {
    final isWater = widget.shape == TabBarShape.waterDrop ||
        widget.indicatorAnimation == TabIndicatorStyle.waterDrop ||
        widget.animation == TabAnimationStyle.waterDrop;
    if (isWater && _controller.isAnimating) return;
    final feedback = _preset.feedback;
    if (feedback == TabFeedbackAnimation.haptic ||
        feedback == TabFeedbackAnimation.elasticPop ||
        feedback == TabFeedbackAnimation.badgePop) {
      HapticFeedback.selectionClick();
    }
    widget.onTap?.call(index);
    if (widget.controller != null) {
      widget.controller!.jumpTo(index);
    } else {
      _animateTo(index);
    }
  }

  bool get _reduceMotion {
    if (!widget.respectReduceMotion) return false;
    return MediaQuery.disableAnimationsOf(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = ResolvedTabColors.resolve(
      context,
      colors: widget.colors,
      backgroundColor: widget.backgroundColor,
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
      indicatorColor: widget.indicatorColor,
      gradient: widget.gradient,
    );
    final bg = c.background;
    final active = c.active;
    final inactive = c.inactive;
    final indicator = c.indicator;
    final preset = _preset;
    final reduce = _reduceMotion;

    final wantsSparkle =
        !reduce && preset.feedback == TabFeedbackAnimation.starTwinkle;
    if (wantsSparkle) {
      if (!_sparkle.isAnimating) _sparkle.repeat();
    } else if (_sparkle.isAnimating) {
      _sparkle
        ..stop()
        ..value = 0;
    }

    final effectiveIndicator = () {
      if (reduce) return TabIndicatorStyle.none;
      if (widget.indicatorAnimation != null) return widget.indicatorAnimation!;
      if (widget.shape == TabBarShape.waterDrop) {
        return TabIndicatorStyle.waterDrop;
      }
      return preset.indicator;
    }();
    final effectiveItem =
        reduce ? TabItemAnimation.fade : preset.item;
    final barMotion = reduce ? TabBarMotion.none : preset.barMotion;
    final isWaterDrop = effectiveIndicator == TabIndicatorStyle.waterDrop ||
        widget.shape == TabBarShape.waterDrop;

    Widget bar = AnimatedBuilder(
      animation: Listenable.merge([_progress, _sparkle]),
      builder: (context, _) {
        final p = isWaterDrop ? _controller.value : _progress.value;
        final sparkleT = _sparkle.value;
        final height = widget.height * (_minimized ? 0.55 : 1);
        final isMaterialNotch = widget.shape == TabBarShape.materialNotch;
        final isCurvedNotch = widget.shape == TabBarShape.curvedNotch;
        final isNotch = isMaterialNotch || isCurvedNotch;
        final isConvexBump = widget.shape == TabBarShape.convexFixed ||
            widget.shape == TabBarShape.convexReact ||
            widget.shape == TabBarShape.bubble ||
            widget.shape == TabBarShape.moonOut;
        final isMoon = widget.shape == TabBarShape.moonIn ||
            widget.shape == TabBarShape.moonOut;
        final isSDivider = widget.shape == TabBarShape.sDivider;
        final isSCurve = widget.shape == TabBarShape.sCurve;
        final isVertical = widget.position == TabBarPosition.left ||
            widget.position == TabBarPosition.right;
        // Room for the floating disc above the bar (kept tight to the disc size).
        const materialFabSize = 34.0;
        final fabSize = materialFabSize;
        final topPad = isMaterialNotch
            ? 20.0
            : (isCurvedNotch ? 8.0 : (isConvexBump ? 22.0 : 0.0));

        return LayoutBuilder(
          builder: (context, constraints) {
            final mq = MediaQuery.sizeOf(context);
            final maxW = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : (isVertical ? height : mq.width);
            final maxH = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : (isVertical ? mq.height : height + topPad);

            final isContainer = widget.shape == TabBarShape.container;
            final resolvedTabExtent = isContainer
                ? (widget.tabExtent ??
                    math.min(50.0, height * 0.48).clamp(36.0, 56.0))
                : 0.0;
            final resolvedTabCorner =
                widget.tabCornerRadius ?? widget.cornerRadius;

            final barSize = isVertical
                ? Size(maxH, height)
                : (isConvexBump
                    ? Size(maxW, height + topPad)
                    : Size(maxW, height));

            late Path path;
            List<Path>? pianoKeys;
            List<Path>? pianoSeams;
            final itemCount = math.max(widget.items.length, 1);
            final mainExtentForPath = barSize.width;
            final itemExtentForPath = mainExtentForPath / itemCount;
            final bumpFrom = (_previousIndex + 0.5) * itemExtentForPath;
            final bumpTo = (_index + 0.5) * itemExtentForPath;
            final curvedNotchCenter = lerpDouble(bumpFrom, bumpTo, p)!;

            if (isContainer) {
              // Match tab_container: morph indicatorStart/End between tabs.
              final count = itemCount;
              final itemW = barSize.width / count;
              final fromStart = _previousIndex * itemW;
              final toStart = _index * itemW;
              final start = lerpDouble(fromStart, toStart, p)!;
              path = buildContainerTabPath(
                size: barSize,
                selectedIndex: _index,
                itemCount: count,
                borderRadius: widget.cornerRadius,
                tabExtent: resolvedTabExtent,
                tabBorderRadius: resolvedTabCorner,
                indicatorStart: start,
                indicatorEnd: start + itemW,
              );
            } else if (isSCurve || isSDivider) {
              pianoKeys = buildPianoKeyPaths(
                size: barSize,
                selectedIndex: _index,
                previousIndex: _previousIndex,
                itemCount: widget.items.length,
                progress: p,
              );
              pianoSeams = buildPianoSeamPaths(
                size: barSize,
                itemCount: widget.items.length,
                selectedIndex: _index,
                previousIndex: _previousIndex,
                progress: p,
              );
              path = Path();
              for (final key in pianoKeys) {
                path.addPath(key, Offset.zero);
              }
            } else {
              path = buildTabBarPath(
                shape: widget.shape,
                size: barSize,
                selectedIndex: _index,
                itemCount: widget.items.length,
                progress: barMotion == TabBarMotion.none ? 1 : p,
                cornerRadius: widget.cornerRadius,
                notchRadius: isCurvedNotch ? 20.0 : fabSize * 0.62,
                tabExtent: resolvedTabExtent,
                tabCornerRadius: resolvedTabCorner,
                bumpCenterX: isCurvedNotch
                    ? curvedNotchCenter
                    : (isMaterialNotch
                        ? barSize.width / 2
                        : (isMoon ? curvedNotchCenter : null)),
                customBuilder: widget.customBarPath,
              );
            }
            if (!isVertical && isNotch && topPad > 0) {
              path = path.shift(Offset(0, topPad));
            }
            if (isVertical) {
              path = rotateBarPathForSide(path, Size(maxH, height));
              if (pianoKeys != null) {
                pianoKeys = [
                  for (final key in pianoKeys)
                    rotateBarPathForSide(key, Size(maxH, height)),
                ];
              }
              if (pianoSeams != null) {
                pianoSeams = [
                  for (final seam in pianoSeams)
                    rotateBarPathForSide(seam, Size(maxH, height)),
                ];
              }
              if (widget.position == TabBarPosition.right) {
                // Mirror so the raised edge faces inward (toward content).
                final w = height;
                final flip = Matrix4.diagonal3Values(-1, 1, 1);
                path = path.transform(flip.storage);
                path = path.shift(Offset(w, 0));
                if (pianoKeys != null) {
                  pianoKeys = [
                    for (final key in pianoKeys)
                      key.transform(flip.storage).shift(Offset(w, 0)),
                  ];
                }
                if (pianoSeams != null) {
                  pianoSeams = [
                    for (final seam in pianoSeams)
                      seam.transform(flip.storage).shift(Offset(w, 0)),
                  ];
                }
              }
            }

            final mainExtent = isVertical ? maxH : maxW;
            final itemExtent = mainExtent / itemCount;
            final from = (_previousIndex + 0.5) * itemExtent;
            final to = (_index + 0.5) * itemExtent;
            // materialNotch: FAB locked to center. curvedNotch: FAB follows tab.
            final fabMain = isMaterialNotch
                ? mainExtent / 2
                : (isCurvedNotch ? lerpDouble(from, to, p)! : 0.0);
            final fabScale = isMaterialNotch
                ? (0.88 + 0.12 * Curves.elasticOut.transform(p.clamp(0.0, 1.0)))
                : 1.0;

            final tabItemAnimation = isWaterDrop
                ? TabItemAnimation.none
                : (isNotch
                    ? TabItemAnimation.colorTween
                    : effectiveItem);
            final tabFeedback = isWaterDrop
                ? TabFeedbackAnimation.none
                : preset.feedback;

            Widget buildSlot(int i) {
              return _TabSlot(
                item: widget.items[i],
                index: i,
                selectedIndex: _index,
                previousIndex: _previousIndex,
                progress: p,
                selected: i == _index,
                activeColor: active,
                selectedIconColor: null,
                inactiveColor: inactive,
                itemAnimation: tabItemAnimation,
                enable3D: widget.enable3D && !reduce && !isWaterDrop,
                threeDStyle: widget.threeDStyle,
                perspective: widget.perspective,
                showLabels: widget.showLabels,
                reduceMotion: reduce,
                feedback: tabFeedback,
                sparkleProgress: sparkleT,
                waterDropMode: isWaterDrop,
                labelActiveColor: c.labelActive,
                labelInactiveColor: c.labelInactive,
                glowColor: c.glow,
                starColor: c.star,
                rippleColor: c.ripple,
                onTap: () => _onTap(i),
              );
            }

            final usePianoHit = (isSCurve || isSDivider) && pianoKeys != null;
            final Widget tabs;
            if (usePianoHit) {
              tabs = Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i < widget.items.length; i++)
                    Positioned.fill(
                      child: _PianoKeyHitTarget(
                        path: pianoKeys[i],
                        child: buildSlot(i),
                      ),
                    ),
                ],
              );
            } else if (isVertical) {
              tabs = Column(
                children: [
                  for (var i = 0; i < widget.items.length; i++)
                    Expanded(child: buildSlot(i)),
                ],
              );
            } else {
              tabs = Row(
                children: [
                  for (var i = 0; i < widget.items.length; i++)
                    Expanded(child: buildSlot(i)),
                ],
              );
            }

            return SizedBox(
              height: isVertical ? maxH : (height + topPad),
              width: isVertical ? height + topPad : maxW,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: (isSCurve || isSDivider) && pianoKeys != null
                        ? CustomPaint(
                            painter: PianoKeysPainter(
                              keys: pianoKeys,
                              seams: pianoSeams ?? const [],
                              selectedIndex: _index,
                              previousIndex: _previousIndex,
                              progress: p,
                              color: bg,
                              pressedColor: c.pressed,
                              seamColor: isSDivider ? c.divider : c.pianoSeam,
                              drawSeamsOnly: false,
                              elevation: widget.elevation.clamp(0, 8),
                            ),
                            child: const SizedBox.expand(),
                          )
                        : TabBarSurfacePainter(
                            path: path,
                            surface: widget.surface,
                            color: bg,
                            gradient: c.gradient,
                            shadowColor: c.shadow,
                            elevation: widget.elevation,
                            clipChild: false,
                            child: const SizedBox.expand(),
                          ),
                  ),
                  if (isMaterialNotch && !isVertical)
                    Positioned(
                      left: fabMain - fabSize / 2,
                      top: topPad - fabSize * 0.55,
                      width: fabSize,
                      height: fabSize,
                      child: IgnorePointer(
                        child: Transform.scale(
                          scale: fabScale,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: c.fab,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: c.shadow.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.add,
                              color: c.fabIcon,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (isCurvedNotch && !isVertical)
                    Positioned(
                      left: fabMain - 3.5,
                      top: 2,
                      width: 7,
                      height: 7,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: indicator,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    // Never set left+right+width or top+bottom+height together.
                    left: isVertical
                        ? (isContainer
                            ? (widget.position == TabBarPosition.right
                                ? height - resolvedTabExtent
                                : 0.0)
                            : topPad)
                        : 0,
                    top: isVertical
                        ? 0
                        : (isContainer || isSCurve || isSDivider ? 0 : topPad),
                    width: isVertical
                        ? (isContainer ? resolvedTabExtent : height)
                        : null,
                    height: isVertical
                        ? null
                        : (isContainer ? resolvedTabExtent : height),
                    right: isVertical ? null : 0,
                    bottom: isVertical ? 0 : null,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Path / FAB is the indicator for container, piano keys, notches.
                        if (!isContainer &&
                            !isSCurve &&
                            !isSDivider &&
                            !isNotch &&
                            !isWaterDrop)
                          Positioned.fill(
                            child: TabIndicatorLayer(
                              animation: effectiveIndicator,
                              selectedIndex: _index,
                              previousIndex: _previousIndex,
                              itemCount: widget.items.length,
                              progress: p,
                              color: indicator,
                              itemShape: widget.itemShape,
                            ),
                          ),
                        tabs,
                      ],
                    ),
                  ),
                  if (isWaterDrop && !isVertical)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: WaterDropNavPainter(
                            selectedIndex: _index,
                            previousIndex: _previousIndex,
                            itemCount: widget.items.length,
                            progress: p,
                            color: indicator,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );

    if (widget.enableDragSelect) {
      bar = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (details) {
          final vx = details.primaryVelocity ?? 0;
          if (vx < -200) {
            _onTap((_index + 1).clamp(0, widget.items.length - 1));
          } else if (vx > 200) {
            _onTap((_index - 1).clamp(0, widget.items.length - 1));
          }
        },
        child: bar,
      );
    }

    if (barMotion == TabBarMotion.minimizeOnScroll) {
      bar = NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n is ScrollUpdateNotification) {
            final dy = n.scrollDelta ?? 0;
            if (dy > 2 && !_minimized) setState(() => _minimized = true);
            if (dy < -2 && _minimized) setState(() => _minimized = false);
          }
          return false;
        },
        child: bar,
      );
    }

    bar = Padding(padding: widget.margin, child: bar);
    if (widget.safeArea) {
      bar = SafeArea(
        top: widget.position == TabBarPosition.top,
        bottom: widget.position == TabBarPosition.bottom,
        left: widget.position == TabBarPosition.left,
        right: widget.position == TabBarPosition.right,
        child: bar,
      );
    }
    return Material(
      type: MaterialType.transparency,
      child: bar,
    );
  }
}

/// Hit-tests a piano key using its outline [path], and centers the child
/// on the path bounds so icons line up with the interlocking S keys.
class _PianoKeyHitTarget extends StatelessWidget {
  const _PianoKeyHitTarget({
    required this.path,
    required this.child,
  });

  final Path path;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bounds = path.getBounds();
    return _PathHitTest(
      path: path,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: bounds.left,
            top: bounds.top,
            width: math.max(bounds.width, 1),
            height: math.max(bounds.height, 1),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _PathHitTest extends SingleChildRenderObjectWidget {
  const _PathHitTest({required this.path, required super.child});

  final Path path;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderPathHitTest(path);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderPathHitTest renderObject,
  ) {
    renderObject.path = path;
  }
}

class _RenderPathHitTest extends RenderProxyBox {
  _RenderPathHitTest(this._path);

  Path _path;
  set path(Path value) {
    if (identical(_path, value)) return;
    _path = value;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!_path.contains(position)) return false;
    return super.hitTest(result, position: position);
  }
}

class _TabSlot extends StatelessWidget {
  const _TabSlot({
    required this.item,
    required this.index,
    required this.selectedIndex,
    required this.previousIndex,
    required this.progress,
    required this.selected,
    required this.activeColor,
    this.selectedIconColor,
    required this.inactiveColor,
    required this.itemAnimation,
    required this.enable3D,
    required this.threeDStyle,
    required this.perspective,
    required this.showLabels,
    required this.reduceMotion,
    required this.feedback,
    this.sparkleProgress = 0,
    this.waterDropMode = false,
    required this.labelActiveColor,
    required this.labelInactiveColor,
    required this.glowColor,
    required this.starColor,
    required this.rippleColor,
    required this.onTap,
  });

  final TabItem item;
  final int index;
  final int selectedIndex;
  final int previousIndex;
  final double progress;
  final bool selected;
  final Color activeColor;
  /// When set, overrides the selected icon tint (e.g. white on curvedNotch disc).
  final Color? selectedIconColor;
  final Color inactiveColor;
  final TabItemAnimation itemAnimation;
  final bool enable3D;
  final Tab3DStyle threeDStyle;
  final double perspective;
  final bool showLabels;
  final bool reduceMotion;
  final TabFeedbackAnimation feedback;
  final double sparkleProgress;
  final bool waterDropMode;
  final Color labelActiveColor;
  final Color labelInactiveColor;
  final Color glowColor;
  final Color starColor;
  final Color rippleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final state = TabMediaState(
      index: index,
      isSelected: selected,
      reduceMotion: reduceMotion,
      animation: selected ? progress : 0,
    );
    final tint = selected && selectedIconColor != null
        ? selectedIconColor!
        : Color.lerp(inactiveColor, activeColor, selected ? progress : 0.15)!;
    final graphic = (selected ? item.activeIcon : null) ?? item.icon;
    final inactiveGraphic = item.icon;
    final activeGraphic = item.activeIcon ?? item.icon;

    Widget icon;
    if (waterDropMode) {
      icon = WaterDropIconReveal(
        progress: progress,
        selected: selected,
        inactiveIcon: inactiveGraphic.build(context, state, tint: inactiveColor),
        activeIcon: activeGraphic.build(context, state, tint: activeColor),
        iconSize: inactiveGraphic.size,
      );
    } else {
      icon = graphic.build(context, state, tint: tint);
    }
    if (feedback == TabFeedbackAnimation.glow ||
        feedback == TabFeedbackAnimation.neonPulse) {
      icon = Container(
        decoration: selected
            ? BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.55),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              )
            : null,
        child: icon,
      );
    }
    if (feedback == TabFeedbackAnimation.starTwinkle) {
      icon = StarTwinkleOverlay(
        progress: sparkleProgress,
        active: selected,
        color: starColor,
        child: icon,
      );
    }

    // Avoid stacking 2D flip/rotate/scale on top of 3D (causes crush/warp).
    final motion = enable3D
        ? TabItemAnimation.colorTween
        : itemAnimation;

    Widget body = TabItemMotion(
      animation: waterDropMode ? TabItemAnimation.none : motion,
      selected: selected,
      progress: progress,
      index: index,
      selectedIndex: selectedIndex,
      label: item.label,
      showLabel: showLabels,
      labelColor: selected ? labelActiveColor : labelInactiveColor,
      child: icon,
    );

    if (enable3D) {
      body = Tab3DTransform(
        style: threeDStyle,
        selected: selected,
        progress: progress,
        index: index,
        selectedIndex: selectedIndex,
        previousIndex: previousIndex,
        perspective: perspective,
        child: body,
      );
    }

    Widget stack = Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        body,
        if (item.badge != null && item.badge!.isVisible)
          Positioned(
            right: 12 + item.badge!.offset.dx,
            top: 6 + item.badge!.offset.dy,
            child: Transform.scale(
              scale: feedback == TabFeedbackAnimation.badgePop && selected
                  ? 0.85 + 0.2 * progress
                  : 1,
              child: item.badge!.build(context, state),
            ),
          ),
      ],
    );

    stack = TabMediaScope(state: state, child: stack);

    Widget button = InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      splashColor: feedback == TabFeedbackAnimation.ripple
          ? rippleColor
          : Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox.expand(
        child: waterDropMode
            ? Align(alignment: Alignment.bottomCenter, child: stack)
            : Center(child: stack),
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      label: item.resolvedSemanticLabel,
      child: button,
    );
  }
}
