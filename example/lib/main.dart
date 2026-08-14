import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tab_animation_pro/tab_animation_pro.dart';

void main() => runApp(const TabExampleApp());

class TabExampleApp extends StatelessWidget {
  const TabExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tab_animation_pro example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final demos = <_DemoItem>[
      _DemoItem('Regular shapes', const RegularShapesPage()),
      _DemoItem('Irregular shapes', const IrregularShapesPage()),
      _DemoItem('Container / S-curve', const ContainerSCurvePage()),
      _DemoItem('Colors', const ColorsDemoPage()),
      _DemoItem('Item shapes', const ItemShapesPage()),
      _DemoItem('Surfaces', const SurfacesPage()),
      _DemoItem('Indicator animations', const IndicatorAnimationsPage()),
      _DemoItem('Item animations', const ItemAnimationsPage()),
      _DemoItem('3D switch', const ThreeDDemoPage()),
      _DemoItem('Badges & external media', const MediaDemoPage()),
      _DemoItem('Top / RTL / Reduce motion', const LayoutExtrasPage()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('tab_animation_pro')),
      body: ListView.separated(
        itemCount: demos.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final demo = demos[index];
          return ListTile(
            title: Text(demo.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => demo.page),
              );
            },
          );
        },
      ),
    );
  }
}

class _DemoItem {
  const _DemoItem(this.title, this.page);
  final String title;
  final Widget page;
}

List<TabItem> _demoItems({TabBadge? badge}) {
  return [
    TabItem(
      label: 'Home',
      icon: TabGraphic.icon(Icons.home_outlined),
      activeIcon: TabGraphic.icon(Icons.home),
      badge: badge,
    ),
    TabItem(
      label: 'Search',
      icon: TabGraphic.icon(Icons.search),
    ),
    TabItem(
      label: 'Alerts',
      icon: TabGraphic.icon(Icons.notifications_outlined),
      activeIcon: TabGraphic.icon(Icons.notifications),
      badge: TabBadge.count(3),
    ),
    TabItem(
      label: 'Profile',
      icon: TabGraphic.icon(Icons.person_outline),
      activeIcon: TabGraphic.icon(Icons.person),
    ),
  ];
}

/// Default demo palette: teal-200 bar vs light scaffold so the surface is obvious.
const _kDemoColors = TabColors(
  background: Color(0xFF99F6E4),
  active: Color(0xFF0F766E),
  inactive: Color(0xFF3F3F46),
  indicator: Color(0xFF0F766E),
  fab: Color(0xFF0F766E),
  fabIcon: Colors.white,
  pressed: Color(0xFF5EEAD4),
  labelActive: Color(0xFF0F766E),
  labelInactive: Color(0xFF3F3F46),
  divider: Color(0xFF0F766E),
  shadow: Color(0x660F766E),
  ripple: Color(0x330F766E),
  glow: Color(0xFF14B8A6),
  star: Color(0xFFF59E0B),
  pianoSeam: Color(0x590F766E),
);

TabColors _surfaceDemoColors(TabBarSurface surface) {
  switch (surface) {
    case TabBarSurface.solid:
      return const TabColors(
        background: Color(0xFF0F766E),
        active: Colors.white,
        inactive: Color(0xB3FFFFFF),
        indicator: Color(0xFF5EEAD4),
        labelActive: Colors.white,
        labelInactive: Color(0xCCFFFFFF),
        fab: Color(0xFF115E59),
        fabIcon: Colors.white,
        shadow: Color(0x800F766E),
      );
    case TabBarSurface.gradient:
      return const TabColors(
        background: Color(0xFF0F766E),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0F766E), Color(0xFF0891B2), Color(0xFF22D3EE)],
        ),
        active: Colors.white,
        inactive: Color(0xB3FFFFFF),
        indicator: Colors.white,
        labelActive: Colors.white,
        labelInactive: Color(0xCCFFFFFF),
        fab: Color(0xFF155E75),
        fabIcon: Colors.white,
      );
    case TabBarSurface.glass:
      return const TabColors(
        background: Color(0xCCE0F2FE),
        active: Color(0xFF0F766E),
        inactive: Color(0xFF1E293B),
        indicator: Color(0xFF0F766E),
        labelActive: Color(0xFF0F766E),
        labelInactive: Color(0xFF334155),
        fab: Color(0xFF0F766E),
        fabIcon: Colors.white,
      );
    case TabBarSurface.neumorphic:
      return const TabColors(
        background: Color(0xFFD5DEE5),
        active: Color(0xFF0F766E),
        inactive: Color(0xFF475569),
        indicator: Color(0xFF0F766E),
        labelActive: Color(0xFF0F766E),
        labelInactive: Color(0xFF475569),
        shadow: Color(0x55000000),
        fab: Color(0xFF0F766E),
        fabIcon: Colors.white,
      );
  }
}

class RegularShapesPage extends StatefulWidget {
  const RegularShapesPage({super.key});

  @override
  State<RegularShapesPage> createState() => _RegularShapesPageState();
}

class _RegularShapesPageState extends State<RegularShapesPage> {
  int index = 0;
  TabBarShape shape = TabBarShape.fixed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Regular shapes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 8,
              children: [
                for (final s in [
                  TabBarShape.fixed,
                  TabBarShape.rounded,
                  TabBarShape.squircle,
                  TabBarShape.floating,
                  TabBarShape.pill,
                  TabBarShape.segmented,
                  TabBarShape.underline,
                ])
                  ChoiceChip(
                    label: Text(s.name),
                    selected: shape == s,
                    onSelected: (_) => setState(() => shape = s),
                  ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: TabAnimationPro(
        items: _demoItems(),
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        shape: shape,
        animation: TabAnimationStyle.slideIndicator,
        colors: _kDemoColors,
      ),
    );
  }
}

class IrregularShapesPage extends StatefulWidget {
  const IrregularShapesPage({super.key});

  @override
  State<IrregularShapesPage> createState() => _IrregularShapesPageState();
}

class _IrregularShapesPageState extends State<IrregularShapesPage> {
  int index = 0;
  TabBarShape shape = TabBarShape.convexReact;
  TabFabLocation fabLocation = TabFabLocation.center;
  TabNotchSmoothness notchSmoothness = TabNotchSmoothness.verySmoothEdge;

  static const shapes = [
    TabBarShape.convexFixed,
    TabBarShape.convexReact,
    TabBarShape.concave,
    TabBarShape.materialNotch,
    TabBarShape.curvedNotch,
    TabBarShape.bubble,
    TabBarShape.wave,
    TabBarShape.waterDrop,
    TabBarShape.moonIn,
    TabBarShape.moonOut,
  ];

  @override
  Widget build(BuildContext context) {
    final isWater = shape == TabBarShape.waterDrop;
    final isMoon = shape == TabBarShape.moonIn || shape == TabBarShape.moonOut;
    final isFab = shape == TabBarShape.materialNotch;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text('Irregular shapes')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in shapes)
                  ChoiceChip(
                    label: Text(s.name),
                    selected: shape == s,
                    onSelected: (_) => setState(() => shape = s),
                  ),
              ],
            ),
            if (isFab) ...[
              const SizedBox(height: 12),
              const Text('FAB 位置（GapLocation）'),
              Wrap(
                spacing: 8,
                children: [
                  for (final loc in TabFabLocation.values)
                    ChoiceChip(
                      label: Text(loc.name),
                      selected: fabLocation == loc,
                      onSelected: (_) => setState(() => fabLocation = loc),
                    ),
                ],
              ),
              if (fabLocation != TabFabLocation.none) ...[
                const SizedBox(height: 8),
                const Text('缺口平滑（NotchSmoothness）'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in TabNotchSmoothness.values)
                      ChoiceChip(
                        label: Text(s.name),
                        selected: notchSmoothness == s,
                        onSelected: (_) =>
                            setState(() => notchSmoothness = s),
                      ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('点 FAB 会重放弹出动画；点 Tab 只播该项动画。'),
                ),
              ],
            ],
          ],
        ),
      ),
      bottomNavigationBar: TabAnimationPro(
        items: _demoItems(),
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        shape: shape,
        barMotion: shape == TabBarShape.curvedNotch
            ? TabBarMotion.followNotch
            : TabBarMotion.none,
        animation: isWater
            ? TabAnimationStyle.waterDrop
            : isMoon || shape == TabBarShape.curvedNotch
                ? TabAnimationStyle.slideIndicator
                : TabAnimationStyle.bounce,
        indicatorAnimation: isWater
            ? TabIndicatorStyle.waterDrop
            : (shape == TabBarShape.materialNotch ||
                    shape == TabBarShape.curvedNotch)
                ? TabIndicatorStyle.none
                : null,
        animationDuration: isWater
            ? const Duration(milliseconds: 800)
            : const Duration(milliseconds: 360),
        animationCurve: isWater ? Curves.linear : Curves.easeOutCubic,
        elevation: isWater ? 0 : 8,
        cornerRadius: isWater
            ? 0
            : (shape == TabBarShape.materialNotch ? 32.0 : 16.0),
        itemAnimation: shape == TabBarShape.curvedNotch
            ? TabItemAnimation.colorTween
            : null,
        feedbackAnimation: isWater
            ? TabFeedbackAnimation.none
            : TabFeedbackAnimation.elasticPop,
        fabConfig: TabFabConfig(
          location: fabLocation,
          smoothness: notchSmoothness,
          onTap: () {},
        ),
        colors: _kDemoColors,
      ),
    );
  }
}

class ContainerSCurvePage extends StatefulWidget {
  const ContainerSCurvePage({super.key});

  @override
  State<ContainerSCurvePage> createState() => _ContainerSCurvePageState();
}

class _ContainerSCurvePageState extends State<ContainerSCurvePage> {
  int index = 0;
  TabBarShape shape = TabBarShape.container;
  TabBarPosition edge = TabBarPosition.bottom;

  @override
  Widget build(BuildContext context) {
    final isSide =
        edge == TabBarPosition.left || edge == TabBarPosition.right;
    final bar = TabAnimationPro(
      items: _demoItems(),
      currentIndex: index,
      onTap: (i) => setState(() => index = i),
      shape: shape,
      position: edge,
      // container needs body + tabExtent room (like tab_container defaults).
      height: shape == TabBarShape.container
          ? (isSide ? 88 : 110)
          : (isSide ? 72 : 64),
      tabExtent: shape == TabBarShape.container ? 48 : null,
      tabCornerRadius: shape == TabBarShape.container ? 12 : null,
      animation: (shape == TabBarShape.sCurve || shape == TabBarShape.sDivider)
          ? TabAnimationStyle.none
          : TabAnimationStyle.slideIndicator,
      colors: _kDemoColors,
      cornerRadius: 16,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Container / S-curve')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in [
                  TabBarShape.container,
                  TabBarShape.sCurve,
                  TabBarShape.sDivider,
                ])
                  ChoiceChip(
                    label: Text(s.name),
                    selected: shape == s,
                    onSelected: (_) => setState(() => shape = s),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Wrap(
              spacing: 8,
              children: [
                for (final e in TabBarPosition.values)
                  ChoiceChip(
                    label: Text(e.name),
                    selected: edge == e,
                    onSelected: (_) => setState(() => edge = e),
                  ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'container ≈ tab_container (rounded body + protruding tab + concave fillets); '
              'sCurve / sDivider = piano keys with interlocking S seams; '
              'selected key taps down then rests flush, with a color crossfade.',
            ),
          ),
          Expanded(
            child: switch (edge) {
              TabBarPosition.top => Column(
                  children: [
                    bar,
                    Expanded(
                      child: Center(
                        child: Text(
                          'Page ${index + 1}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              TabBarPosition.bottom => Center(
                  child: Text(
                    'Page ${index + 1}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              TabBarPosition.left || TabBarPosition.right => Row(
                  children: [
                    if (edge == TabBarPosition.left)
                      SizedBox(
                        width: shape == TabBarShape.container ? 88 : 72,
                        child: bar,
                      ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Page ${index + 1}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                    if (edge == TabBarPosition.right)
                      SizedBox(
                        width: shape == TabBarShape.container ? 88 : 72,
                        child: bar,
                      ),
                  ],
                ),
            },
          ),
        ],
      ),
      bottomNavigationBar: edge == TabBarPosition.bottom ? bar : null,
    );
  }
}

class ColorsDemoPage extends StatefulWidget {
  const ColorsDemoPage({super.key});

  @override
  State<ColorsDemoPage> createState() => _ColorsDemoPageState();
}

class _ColorsDemoPageState extends State<ColorsDemoPage> {
  int index = 0;
  int palette = 0;

  static const palettes = <(String, TabColors)>[
    (
      'Teal',
      TabColors(
        background: Color(0xFF99F6E4),
        active: Color(0xFF0F766E),
        inactive: Color(0xFF3F3F46),
        indicator: Color(0xFF0F766E),
        fab: Color(0xFF0F766E),
        fabIcon: Colors.white,
        pressed: Color(0xFF5EEAD4),
        labelActive: Color(0xFF0F766E),
        labelInactive: Color(0xFF3F3F46),
        star: Color(0xFFF59E0B),
      ),
    ),
    (
      'Indigo',
      TabColors(
        background: Color(0xFFC7D2FE),
        active: Color(0xFF3730A3),
        inactive: Color(0xFF334155),
        indicator: Color(0xFF3730A3),
        fab: Color(0xFF4F46E5),
        fabIcon: Colors.white,
        pressed: Color(0xFFA5B4FC),
        labelActive: Color(0xFF3730A3),
        labelInactive: Color(0xFF334155),
        star: Color(0xFFFBBF24),
      ),
    ),
    (
      'Rose',
      TabColors(
        background: Color(0xFFFECDD3),
        active: Color(0xFFBE123C),
        inactive: Color(0xFF4B5563),
        indicator: Color(0xFFBE123C),
        fab: Color(0xFFE11D48),
        fabIcon: Colors.white,
        pressed: Color(0xFFFFA4B6),
        labelActive: Color(0xFFBE123C),
        labelInactive: Color(0xFF4B5563),
        star: Color(0xFFF59E0B),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final entry = palettes[palette];
    return Scaffold(
      appBar: AppBar(title: const Text('Colors')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          spacing: 8,
          children: [
            for (var i = 0; i < palettes.length; i++)
              ChoiceChip(
                label: Text(palettes[i].$1),
                selected: palette == i,
                onSelected: (_) => setState(() => palette = i),
              ),
          ],
        ),
      ),
      bottomNavigationBar: TabAnimationPro(
        items: _demoItems(),
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        shape: TabBarShape.waterDrop,
        animation: TabAnimationStyle.waterDrop,
        animationDuration: const Duration(milliseconds: 800),
        animationCurve: Curves.linear,
        elevation: 0,
        cornerRadius: 0,
        showLabels: true,
        colors: entry.$2,
      ),
    );
  }
}

class ItemShapesPage extends StatefulWidget {
  const ItemShapesPage({super.key});

  @override
  State<ItemShapesPage> createState() => _ItemShapesPageState();
}

class _ItemShapesPageState extends State<ItemShapesPage> {
  int index = 0;
  TabItemShape itemShape = TabItemShape.stadium;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item shapes')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          spacing: 8,
          children: [
            for (final s in TabItemShape.values)
              if (s != TabItemShape.custom)
                ChoiceChip(
                  label: Text(s.name),
                  selected: itemShape == s,
                  onSelected: (_) => setState(() => itemShape = s),
                ),
          ],
        ),
      ),
      bottomNavigationBar: TabAnimationPro(
        items: _demoItems(),
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        itemShape: itemShape,
        indicatorAnimation: TabIndicatorStyle.slidingPill,
        colors: _kDemoColors,
      ),
    );
  }
}

class SurfacesPage extends StatefulWidget {
  const SurfacesPage({super.key});

  @override
  State<SurfacesPage> createState() => _SurfacesPageState();
}

class _SurfacesPageState extends State<SurfacesPage> {
  int index = 0;
  TabBarSurface surface = TabBarSurface.solid;

  @override
  Widget build(BuildContext context) {
    final colors = _surfaceDemoColors(surface);
    final Color? scaffoldColor;
    final Gradient? bodyGradient;
    switch (surface) {
      case TabBarSurface.solid:
        scaffoldColor = const Color(0xFFF1F5F9);
        bodyGradient = null;
      case TabBarSurface.gradient:
        scaffoldColor = const Color(0xFFF0FDFA);
        bodyGradient = null;
      case TabBarSurface.glass:
        scaffoldColor = null;
        bodyGradient = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F766E), Color(0xFF0891B2), Color(0xFF7C3AED)],
        );
      case TabBarSurface.neumorphic:
        scaffoldColor = const Color(0xFFD5DEE5);
        bodyGradient = null;
    }

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        title: const Text('Surfaces'),
        backgroundColor: surface == TabBarSurface.glass
            ? Colors.transparent
            : scaffoldColor,
        foregroundColor: surface == TabBarSurface.glass ? Colors.white : null,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: bodyGradient),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                children: [
                  for (final s in TabBarSurface.values)
                    ChoiceChip(
                      label: Text(s.name),
                      selected: surface == s,
                      onSelected: (_) => setState(() => surface = s),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TabAnimationPro(
        items: _demoItems(),
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        shape: TabBarShape.floating,
        surface: surface,
        colors: colors,
        elevation: surface == TabBarSurface.glass ? 0 : 10,
      ),
    );
  }
}

class IndicatorAnimationsPage extends StatefulWidget {
  const IndicatorAnimationsPage({super.key});

  @override
  State<IndicatorAnimationsPage> createState() =>
      _IndicatorAnimationsPageState();
}

class _IndicatorAnimationsPageState extends State<IndicatorAnimationsPage> {
  int index = 0;
  TabIndicatorStyle indicator = TabIndicatorStyle.slidingPill;

  @override
  Widget build(BuildContext context) {
    final isWater = indicator == TabIndicatorStyle.waterDrop;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text('Indicator animations')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in TabIndicatorStyle.values)
                if (s != TabIndicatorStyle.custom)
                  ChoiceChip(
                    label: Text(s.name),
                    selected: indicator == s,
                    onSelected: (_) => setState(() => indicator = s),
                  ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: TabAnimationPro(
        items: _demoItems(),
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        animation: indicator == TabIndicatorStyle.waterDrop
            ? TabAnimationStyle.waterDrop
            : indicator == TabIndicatorStyle.starTwinkle
                ? TabAnimationStyle.starTwinkle
                : null,
        indicatorAnimation: indicator,
        itemAnimation: TabItemAnimation.colorTween,
        feedbackAnimation: indicator == TabIndicatorStyle.starTwinkle
            ? TabFeedbackAnimation.starTwinkle
            : null,
        animationDuration: indicator == TabIndicatorStyle.waterDrop
            ? const Duration(milliseconds: 800)
            : const Duration(milliseconds: 360),
        animationCurve: isWater ? Curves.linear : Curves.easeOutCubic,
        elevation: isWater ? 0 : 8,
        cornerRadius: isWater ? 0 : 16,
        showLabels: true,
        colors: _kDemoColors,
      ),
    );
  }
}

class ItemAnimationsPage extends StatefulWidget {
  const ItemAnimationsPage({super.key});

  @override
  State<ItemAnimationsPage> createState() => _ItemAnimationsPageState();
}

class _ItemAnimationsPageState extends State<ItemAnimationsPage> {
  int index = 0;
  TabItemAnimation itemAnim = TabItemAnimation.flashy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item animations')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in TabItemAnimation.values)
              if (s != TabItemAnimation.custom)
                ChoiceChip(
                  label: Text(s.name),
                  selected: itemAnim == s,
                  onSelected: (_) => setState(() => itemAnim = s),
                ),
          ],
        ),
      ),
      bottomNavigationBar: TabAnimationPro(
        items: _demoItems(),
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        indicatorAnimation: TabIndicatorStyle.slidingPill,
        itemAnimation: itemAnim,
        colors: _kDemoColors,
      ),
    );
  }
}

class ThreeDDemoPage extends StatefulWidget {
  const ThreeDDemoPage({super.key});

  @override
  State<ThreeDDemoPage> createState() => _ThreeDDemoPageState();
}

class _ThreeDDemoPageState extends State<ThreeDDemoPage> {
  int index = 0;
  bool enable3D = true;
  Tab3DStyle style = Tab3DStyle.cube;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3D switch')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('enable3D'),
            value: enable3D,
            onChanged: (v) => setState(() => enable3D = v),
          ),
          ListTile(
            title: const Text('threeDStyle'),
            trailing: DropdownButton<Tab3DStyle>(
              value: style,
              onChanged: enable3D
                  ? (v) {
                      if (v != null) setState(() => style = v);
                    }
                  : null,
              items: Tab3DStyle.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: TabAnimationPro(
        items: _demoItems(),
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        enable3D: enable3D,
        threeDStyle: style,
        animation: TabAnimationStyle.none,
        itemAnimation: TabItemAnimation.colorTween,
        colors: _kDemoColors,
      ),
    );
  }
}

class MediaDemoPage extends StatefulWidget {
  const MediaDemoPage({super.key});

  @override
  State<MediaDemoPage> createState() => _MediaDemoPageState();
}

class _MediaDemoPageState extends State<MediaDemoPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final items = [
      TabItem(
        label: 'Lottie',
        icon: TabGraphic.builder((context, state) {
          // Host-supplied Lottie — package has no lottie dependency.
          return Lottie.network(
            'https://assets10.lottiefiles.com/packages/lf20_jcikwtux.json',
            animate: state.isSelected && !state.reduceMotion,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.animation,
              color: state.isSelected ? Colors.teal : Colors.grey,
            ),
          );
        }),
        badge: TabBadge.builder((context, state) {
          return Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
      TabItem(
        label: 'GIF',
        icon: TabGraphic.widget(
          Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/2/2c/Rotating_earth_%28large%29.gif',
            width: 28,
            height: 28,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.gif_box_outlined),
          ),
        ),
        badge: TabBadge.text('GIF'),
      ),
      TabItem(
        label: 'Icon',
        icon: TabGraphic.icon(Icons.star_border),
        activeIcon: TabGraphic.icon(Icons.star),
        badge: TabBadge.count(12),
      ),
      TabItem(
        label: 'Dot',
        icon: TabGraphic.icon(Icons.mail_outline),
        badge: TabBadge.dot(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Badges & external media')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Lottie/GIF are passed from the host app via TabGraphic.builder / '
          'TabGraphic.widget. The package itself does not depend on lottie.',
        ),
      ),
      bottomNavigationBar: TabAnimationPro(
        items: items,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        shape: TabBarShape.rounded,
        animation: TabAnimationStyle.slideIndicator,
        feedbackAnimation: TabFeedbackAnimation.badgePop,
        colors: _kDemoColors,
      ),
    );
  }
}

class LayoutExtrasPage extends StatefulWidget {
  const LayoutExtrasPage({super.key});

  @override
  State<LayoutExtrasPage> createState() => _LayoutExtrasPageState();
}

class _LayoutExtrasPageState extends State<LayoutExtrasPage> {
  int index = 0;
  bool top = false;
  bool rtl = false;

  @override
  Widget build(BuildContext context) {
    final bar = TabAnimationPro(
      items: _demoItems(),
      currentIndex: index,
      onTap: (i) => setState(() => index = i),
      position: top ? TabBarPosition.top : TabBarPosition.bottom,
      respectReduceMotion: true,
      animation: TabAnimationStyle.worm,
      colors: _kDemoColors,
    );

    return Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Top / RTL / Reduce motion'),
          bottom: top ? PreferredSize(preferredSize: const Size.fromHeight(72), child: bar) : null,
        ),
        body: Column(
          children: [
            SwitchListTile(
              title: const Text('Top position'),
              value: top,
              onChanged: (v) => setState(() => top = v),
            ),
            SwitchListTile(
              title: const Text('RTL'),
              value: rtl,
              onChanged: (v) => setState(() => rtl = v),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Respects MediaQuery.disableAnimations (Reduce Motion) via TabMediaState.',
              ),
            ),
          ],
        ),
        bottomNavigationBar: top ? null : bar,
      ),
    );
  }
}
