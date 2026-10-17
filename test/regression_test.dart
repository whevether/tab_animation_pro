import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tab_animation_pro/tab_animation_pro.dart';
import 'package:tab_animation_pro/src/animations/feedback/moon_twinkle.dart';
import 'package:tab_animation_pro/src/animations/feedback/star_twinkle.dart';
import 'package:tab_animation_pro/src/animations/indicator/indicator_layer.dart';
import 'package:tab_animation_pro/src/animations/indicator/water_drop_nav_painter.dart';
import 'package:tab_animation_pro/src/animations/item/water_drop_icon_reveal.dart';
import 'package:tab_animation_pro/src/shapes/piano_keys_painter.dart';

class TrackingScrollController extends ScrollController {
  int listenerCount = 0;
  @override
  void addListener(VoidCallback listener) {
    listenerCount++;
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    listenerCount--;
    super.removeListener(listener);
  }
}

List<TabItem> items(int count, {TabGraphicBuilder? builder}) => List.generate(
  count,
  (i) => TabItem(
    label: 'T$i',
    icon: builder == null
        ? TabGraphic.icon(Icons.home_outlined)
        : TabGraphic.builder(builder),
    activeIcon: builder == null ? TabGraphic.icon(Icons.home) : null,
  ),
);
Widget host(Widget bar, {bool rtl = false, bool reduce = false}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reduce),
    child: Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(bottomNavigationBar: bar),
    ),
  ),
);
List<String?> selected(WidgetTester tester) => tester
    .widgetList<Semantics>(find.byType(Semantics))
    .where((w) => w.properties.selected == true)
    .map((w) => w.properties.label)
    .toList();
TabIndicatorLayer indicator(WidgetTester tester) =>
    tester.widget<TabIndicatorLayer>(find.byType(TabIndicatorLayer));
Future<List<int>> pixel(CustomPainter painter, Size size, int x, int y) async {
  final recorder = ui.PictureRecorder();
  painter.paint(Canvas(recorder), size);
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.ceil(), size.height.ceil());
  final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  final offset = (y * image.width + x) * 4;
  final result = List<int>.generate(4, (i) => bytes!.getUint8(offset + i));
  image.dispose();
  picture.dispose();
  return result;
}

void main() {
  testWidgets(
    'replacing a controller selects its current tab and detaches the old one',
    (tester) async {
      final a = TabAnimationController();
      final b = TabAnimationController(initialIndex: 2);
      await tester.pumpWidget(
        host(TabAnimationPro(items: items(3), controller: a)),
      );
      await tester.pumpWidget(
        host(TabAnimationPro(items: items(3), controller: b)),
      );
      expect(selected(tester), ['T2']);
      a.jumpTo(1);
      await tester.pumpAndSettle();
      expect(selected(tester), ['T2']);
      await tester.pumpWidget(const SizedBox());
      a.dispose();
      b.dispose();
    },
  );
  testWidgets('shrinking items keeps current and previous indices in range', (
    tester,
  ) async {
    final c = TabAnimationController(initialIndex: 3);
    await tester.pumpWidget(
      host(TabAnimationPro(items: items(4), controller: c)),
    );
    await tester.pumpWidget(
      host(TabAnimationPro(items: items(2), controller: c)),
    );
    expect(selected(tester), ['T1']);
    expect(indicator(tester).previousIndex, lessThan(2));
    c.jumpTo(-10);
    await tester.pumpAndSettle();
    expect(selected(tester), ['T0']);
    await tester.pumpWidget(const SizedBox());
    c.dispose();
  });
  testWidgets('invalid initial indices are clamped and empty lists are safe', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(TabAnimationPro(items: items(3), currentIndex: 8)),
    );
    expect(selected(tester), ['T2']);
    await tester.pumpWidget(
      host(TabAnimationPro(items: items(2), currentIndex: -4)),
    );
    expect(selected(tester), ['T0']);
    expect(indicator(tester).previousIndex, lessThan(2));
    await tester.pumpWidget(
      host(const TabAnimationPro(items: [], enableDragSelect: true)),
    );
    await tester.flingFrom(const Offset(400, 550), const Offset(-300, 0), 1000);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(host(TabAnimationPro(items: items(2))));
    expect(selected(tester), ['T0']);
  });
  testWidgets('RTL indicator centers match the actual tab centers', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        TabAnimationPro(
          items: items(3),
          indicatorAnimation: TabIndicatorStyle.dot,
        ),
        rtl: true,
      ),
    );
    final layer = indicator(tester);
    for (var i = 0; i < 3; i++) {
      expect(
        tester.getCenter(find.text('T$i')).dx,
        closeTo(layer.slots!.centerX(i), 0.1),
      );
    }
    expect(layer.slots!.centerX(0), greaterThan(layer.slots!.centerX(2)));
  });
  testWidgets(
    'left and right indicators paint next to the selected vertical tab',
    (tester) async {
      for (final position in [TabBarPosition.left, TabBarPosition.right]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 64,
                  height: 400,
                  child: TabAnimationPro(
                    items: items(4),
                    currentIndex: 3,
                    position: position,
                    indicatorColor: const Color(0xFFFF0000),
                    indicatorAnimation: TabIndicatorStyle.dot,
                  ),
                ),
              ),
            ),
          ),
        );
        final finder = find.byType(TabIndicatorLayer);
        final paint = tester.widget<CustomPaint>(
          find.descendant(of: finder, matching: find.byType(CustomPaint)),
        );
        final rgba = await tester.runAsync(
          () => pixel(paint.painter!, tester.getSize(finder), 8, 350),
        );
        expect(rgba, [255, 0, 0, 255]);
      }
    },
  );
  testWidgets('side piano tabs run from top to bottom', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 64,
            height: 400,
            child: TabAnimationPro(
              items: items(4),
              position: TabBarPosition.left,
              shape: TabBarShape.sCurve,
            ),
          ),
        ),
      ),
    );
    expect(
      tester.getCenter(find.text('T0')).dy,
      lessThan(tester.getCenter(find.text('T3')).dy),
    );
    await tester.tap(find.text('T3'));
    await tester.pumpAndSettle();
    expect(selected(tester), ['T3']);
  });
  testWidgets('updated curves are used for the next transition', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(TabAnimationPro(items: items(3), animationCurve: Curves.linear)),
    );
    await tester.pumpWidget(
      host(
        TabAnimationPro(
          items: items(3),
          currentIndex: 1,
          animationCurve: Curves.easeInCubic,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));
    expect(
      indicator(tester).progress,
      closeTo(Curves.easeInCubic.transform(0.5), 0.01),
    );
  });
  testWidgets(
    'reduce motion settles water drops immediately and suppresses particles',
    (tester) async {
      await tester.pumpWidget(
        host(
          TabAnimationPro(
            items: items(3),
            shape: TabBarShape.waterDrop,
            feedbackAnimation: TabFeedbackAnimation.starTwinkle,
          ),
          reduce: true,
        ),
      );
      await tester.tap(find.text('T1'));
      await tester.pump();
      expect(selected(tester), ['T1']);
      expect(find.byType(WaterDropIconReveal), findsNothing);
      expect(find.byType(StarTwinkleOverlay), findsNothing);
      // Material's tap highlight can finish independently of tab motion.
      await tester.pumpAndSettle();
      expect(tester.hasRunningAnimations, isFalse);
    },
  );
  testWidgets('enabling reduce motion during a transition stops it', (
    tester,
  ) async {
    Widget bar() => TabAnimationPro(
      items: items(3),
      feedbackAnimation: TabFeedbackAnimation.moonTwinkle,
    );
    await tester.pumpWidget(host(bar()));
    await tester.tap(find.text('T1'));
    await tester.pump();
    await tester.pumpWidget(host(bar(), reduce: true));
    expect(indicator(tester).progress, 1);
    expect(find.byType(MoonTwinkleOverlay), findsNothing);
    await tester.pumpAndSettle();
    expect(tester.hasRunningAnimations, isFalse);
  });
  testWidgets('narrow notches and overshoot curves do not throw', (
    tester,
  ) async {
    for (final shape in [
      TabBarShape.materialNotch,
      TabBarShape.curvedNotch,
      TabBarShape.rounded,
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 80,
                child: TabAnimationPro(items: items(2), shape: shape),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull, reason: shape.name);
    }
    await tester.pumpWidget(
      host(
        TabAnimationPro(
          items: items(3),
          itemAnimation: TabItemAnimation.fade,
          animationCurve: Curves.easeOutBack,
        ),
      ),
    );
    await tester.tap(find.text('T1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 180));
    expect(tester.takeException(), isNull);
  });
  test('oversized gaps stay within the available width', () {
    final slots = TabSlotGeometry.of(
      width: 50,
      itemCount: 2,
      location: TabFabLocation.center,
      gapWidth: 72,
    );
    expect(slots.slotWidth, greaterThanOrEqualTo(0));
    expect(slots.gapWidth, 50);
    expect(slots.fabCenterX, 25);
    for (final start in slots.starts) {
      expect(start, inInclusiveRange(0, 50));
    }
  });
  testWidgets('odd tab counts center the FAB and align tabs on each side', (
    tester,
  ) async {
    for (final count in [1, 3, 5]) {
      await tester.pumpWidget(
        host(
          TabAnimationPro(
            items: items(count),
            indicatorAnimation: TabIndicatorStyle.dot,
          ),
        ),
      );
      final geometry = indicator(tester).slots!;
      expect(geometry.fabCenterX, geometry.barWidth / 2);
      expect(
        tester.getCenter(find.byIcon(Icons.add)).dx,
        closeTo(geometry.fabCenterX, 0.1),
      );
      for (var i = 0; i < count; i++) {
        expect(
          tester.getCenter(find.text('T$i')).dx,
          closeTo(geometry.centerX(i), 0.1),
        );
      }
    }
  });
  testWidgets(
    'badge alignment, offset and custom builder dimensions are honored',
    (tester) async {
      Widget bar(Alignment alignment, Offset offset) => host(
        TabAnimationPro(
          items: [
            TabItem(
              label: 'T0',
              icon: TabGraphic.icon(Icons.home),
              badge: TabBadge.builder(
                (context, state) => const SizedBox(key: ValueKey('badge')),
                alignment: alignment,
                offset: offset,
                size: const Size(12, 10),
              ),
            ),
          ],
        ),
      );
      await tester.pumpWidget(bar(Alignment.topLeft, Offset.zero));
      final topLeft = tester.getTopLeft(find.byKey(const ValueKey('badge')));
      expect(
        tester.getSize(find.byKey(const ValueKey('badge'))),
        const Size(12, 10),
      );
      await tester.pumpWidget(bar(Alignment.bottomRight, Offset.zero));
      final bottomRight = tester.getTopLeft(
        find.byKey(const ValueKey('badge')),
      );
      expect(bottomRight.dx, greaterThan(topLeft.dx));
      expect(bottomRight.dy, greaterThan(topLeft.dy));
      await tester.pumpWidget(bar(Alignment.bottomRight, const Offset(3, 4)));
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('badge'))),
        bottomRight + const Offset(3, 4),
      );
    },
  );
  testWidgets('iconMorph cross fades entering and leaving icons', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        TabAnimationPro(
          items: items(2),
          itemAnimation: TabItemAnimation.iconMorph,
          animationCurve: Curves.linear,
        ),
      ),
    );
    await tester.tap(find.text('T1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 90));
    Opacity opacityOf(IconData icon, int index) => tester.widget<Opacity>(
      find
          .ancestor(
            of: find.byIcon(icon).at(index),
            matching: find.byType(Opacity),
          )
          .first,
    );
    expect(opacityOf(Icons.home, 1).opacity, closeTo(0.25, 0.01));
    expect(opacityOf(Icons.home, 0).opacity, closeTo(0.75, 0.01));
    await tester.pumpAndSettle();
    expect(opacityOf(Icons.home, 1).opacity, 1);
  });
  testWidgets(
    'scroll controller minimizes and restores a bottom navigation bar',
    (tester) async {
      final scroll = TrackingScrollController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              controller: scroll,
              children: List.generate(
                30,
                (i) => SizedBox(height: 80, child: Text('$i')),
              ),
            ),
            bottomNavigationBar: TabAnimationPro(
              items: items(4),
              barMotion: TabBarMotion.minimizeOnScroll,
              scrollController: scroll,
              fabConfig: const TabFabConfig(location: TabFabLocation.none),
            ),
          ),
        ),
      );
      final original = tester.getSize(find.byType(TabAnimationPro)).height;
      scroll.jumpTo(100);
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(TabAnimationPro)).height,
        closeTo(original * 0.55, 0.1),
      );
      expect(tester.takeException(), isNull);
      scroll.jumpTo(10);
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(TabAnimationPro)).height, original);
      await tester.pumpWidget(const SizedBox());
      expect(scroll.listenerCount, 0);
      scroll.dispose();
    },
  );
  test('particle count changes invalidate both painters', () {
    expect(
      StarTwinklePainter(
        progress: 0,
        color: Colors.red,
        count: 6,
      ).shouldRepaint(StarTwinklePainter(progress: 0, color: Colors.red)),
      isTrue,
    );
    expect(
      MoonTwinklePainter(
        progress: 0,
        color: Colors.red,
        count: 6,
      ).shouldRepaint(MoonTwinklePainter(progress: 0, color: Colors.red)),
      isTrue,
    );
  });
  testWidgets('idle particles repaint without rebuilding host graphics', (
    tester,
  ) async {
    var builds = 0;
    await tester.pumpWidget(
      host(
        TabAnimationPro(
          items: items(
            3,
            builder: (_, _) {
              builds++;
              return const Icon(Icons.home);
            },
          ),
          feedbackAnimation: TabFeedbackAnimation.starTwinkle,
        ),
      ),
    );
    final before = builds;
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect(builds, before);
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpWidget(const SizedBox());
    expect(tester.hasRunningAnimations, isFalse);
  });
  testWidgets(
    'spring configuration changes liquid transition timing and settles',
    (tester) async {
      Widget bar(TabSpringConfig spring) => host(
        TabAnimationPro(
          items: items(3),
          indicatorAnimation: TabIndicatorStyle.liquidBlob,
          itemShape: TabItemShape.stadium,
          spring: spring,
        ),
      );
      await tester.pumpWidget(bar(const TabSpringConfig()));
      await tester.tap(find.text('T1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 90));
      final standard = indicator(tester).progress;
      await tester.pumpWidget(
        bar(const TabSpringConfig(stiffness: 30, damping: 25)),
      );
      expect(indicator(tester).progress, isNot(closeTo(standard, 0.01)));
      await tester.pumpAndSettle();
      expect(indicator(tester).progress, 1);
    },
  );
  testWidgets('piano elevation paints a shadow', (tester) async {
    final keys = [Path()..addRect(const Rect.fromLTWH(10, 10, 40, 20))];
    PianoKeysPainter painter(double elevation) => PianoKeysPainter(
      keys: keys,
      selectedIndex: 0,
      previousIndex: 0,
      progress: 1,
      color: Colors.white,
      pressedColor: Colors.white,
      seamColor: Colors.transparent,
      elevation: elevation,
      shadowColor: Colors.black,
    );
    final flat = await tester.runAsync(
      () => pixel(painter(0), const Size(80, 60), 30, 32),
    );
    final raised = await tester.runAsync(
      () => pixel(painter(8), const Size(80, 60), 30, 32),
    );
    expect(flat!.last, 0);
    expect(raised!.last, greaterThan(0));
  });
  testWidgets('all built-in shapes lay out in RTL and at every edge', (
    tester,
  ) async {
    for (final shape in TabBarShape.values.where(
      (shape) => shape != TabBarShape.custom,
    )) {
      for (final position in TabBarPosition.values) {
        final vertical =
            position == TabBarPosition.left || position == TabBarPosition.right;
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: vertical ? 64 : 360,
                    height: vertical ? 400 : 160,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: TabAnimationPro(
                        items: items(3),
                        shape: shape,
                        position: position,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull, reason: '$shape / $position');
        final first = tester.getCenter(find.text('T0'));
        final last = tester.getCenter(find.text('T2'));
        if (vertical) {
          expect(first.dy, lessThan(last.dy), reason: '$shape / $position');
        } else {
          expect(first.dx, greaterThan(last.dx), reason: '$shape / $position');
        }
      }
    }
  });
  testWidgets('vertical and RTL drags follow the visual direction', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(TabAnimationPro(items: items(3), enableDragSelect: true), rtl: true),
    );
    await tester.fling(
      find.byType(TabAnimationPro),
      const Offset(300, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(selected(tester), ['T1']);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 64,
            height: 400,
            child: TabAnimationPro(
              items: items(3),
              position: TabBarPosition.left,
              enableDragSelect: true,
            ),
          ),
        ),
      ),
    );
    await tester.fling(
      find.byType(TabAnimationPro),
      const Offset(0, -200),
      1000,
    );
    await tester.pumpAndSettle();
    expect(selected(tester), ['T1']);
  });
  testWidgets('vertical water drops paint beside the selected slot', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 64,
            height: 400,
            child: TabAnimationPro(
              items: items(4),
              position: TabBarPosition.left,
              shape: TabBarShape.waterDrop,
              indicatorColor: const Color(0xFFFF0000),
            ),
          ),
        ),
      ),
    );
    final paint = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .firstWhere((w) => w.painter is WaterDropNavPainter);
    final rgba = await tester.runAsync(
      () => pixel(paint.painter!, const Size(64, 400), 56, 50),
    );
    expect(rgba, [255, 0, 0, 255]);
  });
}
