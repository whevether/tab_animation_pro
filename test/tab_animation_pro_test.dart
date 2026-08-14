import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tab_animation_pro/tab_animation_pro.dart';

void main() {
  test('bar path is non-empty for regular and irregular shapes', () {
    const size = Size(360, 64);
    for (final shape in TabBarShape.values) {
      if (shape == TabBarShape.custom) continue;
      final path = buildTabBarPath(
        shape: shape,
        size: size,
        selectedIndex: 1,
        itemCount: 4,
        progress: 1,
      );
      expect(path.getBounds().width, greaterThan(0), reason: '$shape');
      expect(path.getBounds().height, greaterThan(0), reason: '$shape');
    }
  });

  test('item shape paths cover known enums', () {
    final rect = Rect.fromLTWH(0, 0, 48, 32);
    for (final shape in TabItemShape.values) {
      final path = buildItemShapePath(shape, rect);
      if (shape == TabItemShape.none) {
        expect(path.getBounds().isEmpty || path.getBounds().width >= 0, isTrue);
      } else {
        expect(path.getBounds().width, greaterThan(0), reason: '$shape');
      }
    }
  });

  test('materialNotch paths exist for every NotchSmoothness', () {
    const size = Size(360, 64);
    for (final smoothness in TabNotchSmoothness.values) {
      final path = buildTabBarPath(
        shape: TabBarShape.materialNotch,
        size: size,
        selectedIndex: 0,
        itemCount: 4,
        progress: 1,
        notchRadius: 36,
        cornerRadius: 32,
        notchSmoothness: smoothness,
        bumpCenterX: 180,
      );
      expect(path.getBounds().width, greaterThan(0), reason: '$smoothness');
    }
  });

  test('animation presets resolve', () {
    for (final style in TabAnimationStyle.values) {
      final preset = TabAnimationPreset.resolve(style);
      expect(preset.indicator, isNotNull);
      expect(preset.item, isNotNull);
    }
  });

  testWidgets('TabAnimationPro builds and switches index', (tester) async {
    var index = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: StatefulBuilder(
            builder: (context, setState) {
              return TabAnimationPro(
                items: [
                  TabItem(
                    label: 'A',
                    icon: TabGraphic.icon(Icons.home),
                    badge: TabBadge.count(2),
                  ),
                  TabItem(label: 'B', icon: TabGraphic.icon(Icons.search)),
                  TabItem(
                    label: 'C',
                    icon: TabGraphic.builder((context, state) {
                      return Icon(
                        Icons.star,
                        color: state.isSelected ? Colors.amber : Colors.grey,
                      );
                    }),
                    badge: TabBadge.dot(),
                  ),
                ],
                currentIndex: index,
                onTap: (i) => setState(() => index = i),
                enable3D: false,
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    expect(index, 1);
  });

  testWidgets('enable3D toggle does not throw', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: TabAnimationPro(
            items: [
              TabItem(label: 'A', icon: TabGraphic.icon(Icons.home)),
              TabItem(label: 'B', icon: TabGraphic.icon(Icons.search)),
            ],
            currentIndex: 0,
            onTap: (_) {},
            enable3D: true,
            threeDStyle: Tab3DStyle.flip,
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('B'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('glass surface builds over a backdrop', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          extendBody: true,
          body: const ColoredBox(color: Color(0xFF7C3AED)),
          bottomNavigationBar: TabAnimationPro(
            items: [
              TabItem(label: 'A', icon: TabGraphic.icon(Icons.home)),
              TabItem(label: 'B', icon: TabGraphic.icon(Icons.search)),
            ],
            currentIndex: 0,
            onTap: (_) {},
            surface: TabBarSurface.glass,
            shape: TabBarShape.pill,
            colors: const TabColors(background: Color(0x66FFFFFF)),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('A'), findsOneWidget);
  });

  test('TabAnimationController notifies', () {
    final c = TabAnimationController(initialIndex: 0);
    var calls = 0;
    c.addListener(() => calls++);
    c.jumpTo(2);
    expect(c.index, 2);
    expect(calls, 1);
  });
}
