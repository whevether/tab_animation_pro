# tab_animation_pro

Flutter tab bar with regular/irregular shapes, layered animations, optional 3D, and host-supplied icons/badges. Works on Android, iOS, Web, macOS, Windows, and Linux.

Pure Dart — no plugins. Lottie / GIF stay in the host app.

[中文说明](README-ZH.md) · [Changelog](CHANGELOG.md)

- [Install](#install)
- [Where to put it](#where-to-put-it)
- [Quick start](#quick-start)
- [TabAnimationPro parameters](#tabanimationpro-parameters)
- [TabItem](#tabitem)
- [TabGraphic](#tabgraphic)
- [TabBadge](#tabbadge)
- [TabMediaState](#tabmediastate)
- [Controller](#controller)
- [Bar shapes](#bar-shapes)
- [Position](#position)
- [Item shapes](#item-shapes)
- [Surfaces](#surfaces)
- [Animations](#animations)
- [3D](#3d)
- [Colors](#colors)
- [Recipes](#recipes)
- [Gestures, SafeArea, reduce motion](#gestures-safearea-reduce-motion)
- [Custom bar path](#custom-bar-path)
- [Example](#example)

## Install

```yaml
dependencies:
  tab_animation_pro: ^0.1.0
```

```bash
flutter pub get
```

```dart
import 'package:tab_animation_pro/tab_animation_pro.dart';
```

## Where to put it

`TabAnimationPro` is a normal widget. Match `position` to the slot so side bars rotate the path the right way.

```dart
Scaffold(
  body: pages[index],
  bottomNavigationBar: bar, // position: TabBarPosition.bottom (default)
  appBar: bar,              // position: TabBarPosition.top
);
```

Do **not** put a side bar in `bottomNavigationBar` (it will overflow). Place it in a `Row`:

```dart
Scaffold(
  body: Row(
    children: [
      SizedBox(width: 72, child: bar), // position: TabBarPosition.left
      Expanded(child: pages[index]),
    ],
  ),
);
```

Right edge: `Row(children: [Expanded(...), SizedBox(width: 72, child: bar)])` with `position: TabBarPosition.right`.

## Quick start

```dart
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Page $index')),
      bottomNavigationBar: TabAnimationPro(
        items: [
          TabItem(
            label: 'Home',
            icon: TabGraphic.icon(Icons.home_outlined),
            activeIcon: TabGraphic.icon(Icons.home),
            badge: TabBadge.count(3),
          ),
          TabItem(label: 'Search', icon: TabGraphic.icon(Icons.search)),
          TabItem(
            label: 'Alerts',
            icon: TabGraphic.icon(Icons.notifications_outlined),
            activeIcon: TabGraphic.icon(Icons.notifications),
          ),
          TabItem(
            label: 'Profile',
            icon: TabGraphic.icon(Icons.person_outline),
            activeIcon: TabGraphic.icon(Icons.person),
          ),
        ],
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        shape: TabBarShape.rounded,
        animation: TabAnimationStyle.slideIndicator,
      ),
    );
  }
}
```

You own selection: update `index` in `onTap` and pass it back as `currentIndex`. Without a `controller`, changing `currentIndex` plays the switch animation.

## TabAnimationPro parameters

| Parameter | Type | Default | Meaning |
|-----------|------|---------|---------|
| `items` | `List<TabItem>` | required | Tabs. 2–5 is typical; even count is best for `materialNotch`. |
| `currentIndex` | `int` | `0` | Selected index. With a `controller`, taps call `controller.jumpTo`; `currentIndex` is still the initial value. |
| `onTap` | `ValueChanged<int>?` | `null` | Tap callback. Water-drop ignores taps while the drop is animating. |
| `controller` | `TabAnimationController?` | `null` | Programmatic index. When set, taps use `jumpTo` instead of your `currentIndex` setter. |
| `shape` | `TabBarShape` | `fixed` | Bar outline. |
| `itemShape` | `TabItemShape` | `none` | Highlight shape for the selected slot. `none` draws no capsule. Disabled for container / piano / notch / waterDrop. |
| `surface` | `TabBarSurface` | `solid` | Fill treatment. |
| `animation` | `TabAnimationStyle?` | `null` | Preset (indicator + item + feedback + bar motion). If unset: indicator `slidingPill`, item `colorTween`. |
| `indicatorAnimation` | `TabIndicatorStyle?` | `null` | Overrides the preset indicator. |
| `itemAnimation` | `TabItemAnimation?` | `null` | Overrides the preset item motion. `enable3D` forces `colorTween`. Water-drop forces `none`. |
| `feedbackAnimation` | `TabFeedbackAnimation?` | `null` | Overrides preset feedback. Water-drop forces `none`. |
| `barMotion` | `TabBarMotion?` | `null` | Overrides preset path motion. |
| `enable3D` | `bool` | `false` | Perspective per item. Ignored in water-drop mode. |
| `threeDStyle` | `Tab3DStyle` | `flip` | 3D style. |
| `perspective` | `double` | `0.0008` | Clamped to `0.0002–0.0015`. |
| `spring` | `TabSpringConfig` | 120 / 14 / 1 | Reserved for overshoot / liquid transitions. |
| `respectReduceMotion` | `bool` | `true` | Honors `MediaQuery.disableAnimations`: indicator `none`, item `fade`, bar motion `none`, no 3D. |
| `enableDragSelect` | `bool` | `false` | Horizontal fling on the bar (`\|v\| > 200`) selects the neighbor. |
| `position` | `TabBarPosition` | `bottom` | Which edge; drives path rotation and SafeArea. |
| `height` | `double` | `64` | Bar thickness (cross-section on side bars). `minimizeOnScroll` shrinks to 55%. |
| `backgroundColor` | `Color?` | theme | Shortcut; overrides `colors.background`. |
| `activeColor` | `Color?` | `primary` | Shortcut for selected tint. |
| `inactiveColor` | `Color?` | `onSurfaceVariant` | Shortcut for unselected tint. |
| `indicatorColor` | `Color?` | same as active | Indicator / drip / curvedNotch dot. |
| `colors` | `TabColors` | empty | Full palette. |
| `gradient` | `Gradient?` | `null` | Shortcut; overrides `colors.gradient`. |
| `elevation` | `double` | `8` | Shadow. Piano keys clamp to 0–8. |
| `cornerRadius` | `double` | `16` | Corners. Use ~`32` for `materialNotch` to match the reference. |
| `tabExtent` | `double?` | ~42% of `height` (36–56) | `container` only: protruding strip height. |
| `tabCornerRadius` | `double?` | `cornerRadius` | `container` only: strip corners. |
| `margin` | `EdgeInsetsGeometry` | `zero` | Outer margin. |
| `animationDuration` | `Duration` | 360ms | Switch duration. Water-drop: **800ms**. |
| `animationCurve` | `Curve` | `easeOutCubic` | Water-drop must be **`Curves.linear`** (the drip uses the raw 0–1 controller). |
| `showLabels` | `bool` | `true` | Draw `TabItem.label`. Also applies to water-drop. |
| `customBarPath` | `TabBarPathBuilder?` | `null` | Used when `shape: custom`. |
| `safeArea` | `bool` | `true` | Pads only the edge that matches `position`. |
| `fabConfig` | `TabFabConfig` | center + verySmoothEdge | FAB. Ignored on `container` / `sCurve` / `sDivider`. Only `center` cuts a circular notch and splits tabs; `topLeft` / `topRight` / `left` / `right` sit outside the bar. |

## TabItem

```dart
TabItem(
  icon: TabGraphic.icon(Icons.home_outlined),
  activeIcon: TabGraphic.icon(Icons.home), // optional; falls back to icon
  label: 'Home',
  badge: TabBadge.count(3),
  semanticLabel: 'Home', // a11y; defaults to label
)
```

| Field | Meaning |
|-------|---------|
| `icon` | Unselected (or only) graphic. Required. |
| `activeIcon` | Selected graphic. Water-drop uses it for the filled reveal. |
| `label` | Text under the icon. Hidden when `showLabels: false`. |
| `badge` | Overlay on the item stack. |
| `semanticLabel` | `Semantics` label. |

## TabGraphic

No Lottie/network dependency in the package. Four factories:

```dart
TabGraphic.icon(Icons.search, size: 24);           // tinted by active/inactive
TabGraphic.image(AssetImage('assets/tab.png'));
TabGraphic.widget(MyLottieIcon());                 // boxed to size×size
TabGraphic.builder((context, state) {
  return Lottie.asset(
    'assets/home.json',
    animate: state.isSelected && !state.reduceMotion,
  );
});
```

| Factory | Behavior |
|---------|----------|
| `icon` | `Icon`; the bar passes a `tint` that lerps toward `activeColor`. |
| `image` | `Image`, `BoxFit.contain`, `gaplessPlayback: true`. |
| `widget` | Wrapped in `SizedBox`; the bar does not tint it. |
| `builder` | Rebuilt with `TabMediaState` — use for Lottie/GIF. |

`size` defaults to `24`. The water-drop reveal circle uses that size.

## TabBadge

Drawn on a `Stack` over icon+label (`clip: none`), defaulting to top-right.

```dart
TabBadge.dot();
TabBadge.count(12);          // >99 → 99+
TabBadge.text('NEW');
TabBadge.widget(Image.asset('assets/badge.gif', width: 16, height: 16));
TabBadge.builder((context, state) { /* ... */ });
```

Shared args: `color`, `textColor`, `alignment` (default `topRight`), `offset` (default `Offset(4, -4)`), `size`.

Visibility: `count == 0` or empty text is hidden; `dot` / `widget` / `builder` stay visible.

`feedbackAnimation: badgePop` scales the selected item’s badge with progress.

## TabMediaState

Available to `TabGraphic.builder` / `TabBadge.builder` and via `TabMediaScope.of(context)`:

| Field | Meaning |
|-------|---------|
| `index` | Item index |
| `isSelected` | Whether this tab is selected |
| `reduceMotion` | Reduce-motion flag |
| `animation` | Item transition 0–1 (typically 0 when unselected) |

## Controller

```dart
final controller = TabAnimationController(initialIndex: 0);

TabAnimationPro(
  items: items,
  controller: controller,
  onTap: (i) => setState(() {}),
);

controller.jumpTo(2);
controller.animateTo(2); // currently same as jumpTo; the bar owns the ticker
controller.next(itemCount: items.length);
controller.previous(itemCount: items.length);
```

With a `controller`, taps call `jumpTo`. The host still needs `addListener` or `onTap` + `setState` to rebuild page content.

Without a `controller`, changing `currentIndex` from outside plays the same animation.

## Bar shapes

`shape` is the bar `Path`. Some shapes own the indicator layer (no `slidingPill`).

### Regular

| Value | Look |
|-------|------|
| `fixed` | Sharp rectangle |
| `rounded` | Top corners (`cornerRadius`) |
| `squircle` | Softer continuous corners |
| `floating` | Inset rounded strip |
| `pill` | Stadium |
| `segmented` | Flat segmented bar |
| `underline` | Thin bar; pair with a line indicator |

### Convex / wave

| Value | Look |
|-------|------|
| `convexFixed` | Fixed center bump |
| `convexReact` | Bump follows selection |
| `concave` | Center dip, no FAB hole |
| `bubble` | Rounder bump |
| `wave` | Sine top edge; `waveTravel` shifts phase |

### materialNotch

Center-docked FAB cutout aligned with [animated_bottom_navigation_bar](https://pub.dev/packages/animated_bottom_navigation_bar) (`CircularNotchedAndCorneredRectangle`, `verySmoothEdge`).

`fabConfig` works on **every shape except** `container` / `sCurve` / `sDivider` (including water-drop). Only `center` cuts a notch.

| Effect | How |
|--------|-----|
| No FAB | `TabFabLocation.none` |
| Center docked | `TabFabLocation.center`: notch + tabs split in the middle |
| Outside top-left / top-right | `TabFabLocation.topLeft` / `topRight` |
| Outside far left / far right | `TabFabLocation.left` / `right` |

- FAB diameter 56, notch margin 8; `center` sits on the bar’s top edge
- Only `center` splits tabs. Prefer an **even** item count for `center`
- Outside locations do not cut a notch or insert a gap
- Hole is the bar fill; the Scaffold behind it should contrast
- `cornerRadius: 32` matches the reference
- Tapping a **tab** plays `itemAnimation`. The FAB stays still on tab switch; tap the FAB for `fabConfig.onTap` (optional pop animation)

```dart
TabAnimationPro(
  items: items, // 4 items
  currentIndex: index,
  onTap: onTap,
  shape: TabBarShape.materialNotch,
  animation: TabAnimationStyle.bounce,
  indicatorAnimation: TabIndicatorStyle.none,
  cornerRadius: 32,
  colors: TabColors(fab: Colors.teal, fabIcon: Colors.white),
)
```

### curvedNotch

Shallower notch + a small top disc that follows selection. Set `barMotion: TabBarMotion.followNotch` or the notch stays put.

### waterDrop

Hanging drip + falling bead, aligned with [water_drop_nav_bar](https://pub.dev/packages/water_drop_nav_bar).

- **Labels, icons, and badges stay visible**; content sits low so the drip has room
- After the drop lands, the **top drip stays on the selected tab**
- Selected icon uses a circular reveal; pair `icon` / `activeIcon`
- Duration **800ms** + **`Curves.linear`**
- Taps ignored while animating
- Bar fill and drip (`indicatorColor`) must differ
- Drip is painted on horizontal bars only
- `fabConfig` can add a FAB; only `center` splits tabs and cuts a notch so the drip tracks the real slot. Outside locations do not insert a gap

```dart
shape: TabBarShape.waterDrop,
animation: TabAnimationStyle.waterDrop,
animationDuration: const Duration(milliseconds: 800),
animationCurve: Curves.linear,
elevation: 0,
cornerRadius: 0,
showLabels: true,
backgroundColor: Colors.white,
indicatorColor: Colors.teal,
fabConfig: const TabFabConfig(location: TabFabLocation.center),
```

You can also set `indicatorAnimation: TabIndicatorStyle.waterDrop` on another shape; still use 800ms linear.

### moonIn / moonOut

Crescent on the selected slot: cut inward vs bulge outward.

### container

[tab_container](https://pub.dev/packages/tab_container) style: joined body, selected segment rises, S-shoulders on both sides. Height `tabExtent` (default ~42% of bar height, clamped 36–56), corners `tabCornerRadius`. The strip lerps between tabs while switching.

### sCurve / sDivider

Interlocking piano keys.

- Selected key **presses then returns**; at rest all keys share the same top
- Fill crossfades with `colors.pressed`
- `sCurve` fills keys; `sDivider` emphasizes seams (`colors.divider`)
- Hits use `Path.contains` so taps match the S silhouette
- Pair with `animation: TabAnimationStyle.none` so item bounce does not fight the press

### custom

```dart
shape: TabBarShape.custom,
customBarPath: (size, selectedIndex, itemCount, progress) {
  return Path()..addRRect(
    RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
  );
},
```

Signature: `Path Function(Size size, int selectedIndex, int itemCount, double progress)`.

## Position

| Value | Use |
|-------|-----|
| `bottom` | `Scaffold.bottomNavigationBar` |
| `top` | Top bar; SafeArea pads top |
| `left` / `right` | Side bar. Horizontal path is rotated −90°; `right` is mirrored so bumps face content |

Give side bars a finite width (`SizedBox(width: height)`). Do not put them in an unbounded `Row` child.

## Item shapes

`itemShape` clips a highlight in the indicator layer. **`none` draws no highlight** (no selected ellipse). These bar shapes skip that layer so they do not fight their own path / FAB / drip: `container`, `sCurve`, `sDivider`, `materialNotch`, `curvedNotch`, `waterDrop`.

Values: `none`, `circle`, `stadium`, `hexagon`, `diamond`, `trapezoid`, `parallelogram`, `leaf`, `custom`.

## Surfaces

| Value | Fill |
|-------|------|
| `solid` | `background` |
| `gradient` | `colors.gradient` / `gradient` |
| `glass` | Liquid frost: live backdrop blur, Rec. 709 vibrancy, specular rim (`Scaffold.extendBody`) |
| `neumorphic` | Soft highlight / shadow |

## Animations

Four layers. Resolve order:

1. Expand `animation` preset if set
2. Override with `indicatorAnimation` / `itemAnimation` / `feedbackAnimation` / `barMotion`
3. If no preset: indicator `slidingPill`, item `colorTween`
4. `shape == waterDrop` forces indicator `waterDrop` (unless reduce-motion)

### Presets `TabAnimationStyle`

| Preset | Indicator | Item | Feedback | Bar motion |
|--------|-----------|------|----------|------------|
| `none` | none | none | none | none |
| `fade` | none | fade | | |
| `scale` | none | scale | | |
| `slideIndicator` | slidingPill | colorTween | | |
| `bounce` | bubblePop | bounce | | |
| `flip` | none | flip | | |
| `rotate` | none | rotate | | |
| `liquidMorph` | liquidMorph | scale | | blobFollow |
| `labelReveal` | none | labelReveal | | |
| `shift` | none | shift | | |
| `snake` | snake | scale | | |
| `worm` | worm | bounce | | |
| `waterDrop` | waterDrop | none | | |
| `starTwinkle` | starTwinkle | pulse | starTwinkle | |
| `chipExpand` | chipExpand | labelReveal | | |
| `flashy` | none | flashy | | |
| `bubblePop` | bubblePop | bounce | | |
| `inkDrop` | inkDrop | scale | | |
| `floatingDot` | floatingDot | bounce | | |
| `spotlight` | gradientSpotlight | fade | | |
| `squeeze` | slidingPill | squeezeStretch | | |
| `neonPulse` | slidingPill | pulse | neonPulse | |
| `iconMorph` | none | iconMorph | | |
| `slidingClipped` | none | slidingClipped | | |
| `parallax` | slidingPill | parallax | | |

### Indicator `TabIndicatorStyle`

| Value | Effect |
|-------|--------|
| `none` | No extra indicator |
| `slidingPill` | Capsule slides to the selection |
| `slideLine` | Underline slides |
| `worm` | Elastic stretching underline |
| `snake` | Thick bar crawls |
| `topSweep` | Top edge sweep |
| `bubblePop` | Soft circle behind the icon |
| `dot` / `floatingDot` | Dot / slightly raised dot |
| `inkDrop` | Ink spread |
| `gradientSpotlight` | Gradient spotlight |
| `waterDrop` | See water-drop shape |
| `starTwinkle` | Sparkles (with feedback) |
| `liquidBlob` / `liquidMorph` | Liquid blob |
| `chipExpand` | Chip expansion |
| `custom` | Reserved |

### Item `TabItemAnimation`

Applied around the icon; labels sit in a `Column` under it.

| Value | Effect |
|-------|--------|
| `none` / `colorTween` / `custom` | No transform (tint still lerps) |
| `fade` | Opacity |
| `scale` | Scale |
| `bounce` | Sinusoidal scale pop |
| `flip` | Y-axis flip with light perspective |
| `rotate` | **Icon and label together** spin 180° then settle (`0° → 180° → 0°`) |
| `shift` | Translate up 6px |
| `labelReveal` / `flashy` | Shift up; selected label is bold (unselected labels stay visible) |
| `iconMorph` | Opacity handoff (pair with `activeIcon`) |
| `slidingClipped` | Height clip |
| `squeezeStretch` | Wider / shorter squash |
| `parallax` | Horizontal offset vs the selection |
| `pulse` | Ongoing scale |
| `wiggle` | Ongoing rotation |

When `showLabels` is true every item keeps its label. `shift` / `labelReveal` / `flashy` only lift the icon; they no longer drive unselected label opacity to 0.

### Feedback `TabFeedbackAnimation`

| Value | Effect |
|-------|--------|
| `none` | Off |
| `ripple` | InkWell splash (`colors.ripple`) |
| `glow` / `neonPulse` | Icon glow (`colors.glow`) |
| `elasticPop` | Haptic |
| `badgePop` | Scale selected badge |
| `haptic` | Haptic only |
| `starTwinkle` | Sparkles (`colors.star`) |

### Bar `TabBarMotion`

| Value | Effect |
|-------|--------|
| `none` | Path does not morph with progress (piano press still uses progress) |
| `followNotch` | `curvedNotch` tracks selection |
| `waveTravel` | Wave phase follows progress |
| `blobFollow` | Liquid blob follows |
| `minimizeOnScroll` | Shrinks to 55% height on downward scroll |

`minimizeOnScroll` listens on the **bar**. A bar in `Scaffold.bottomNavigationBar` does **not** see `ListView` notifications from `body`. Put the bar under an ancestor of the scroll view, or drive `height` yourself.

## 3D

```dart
enable3D: true,
threeDStyle: Tab3DStyle.coverflow,
perspective: 0.0008,
```

| Value | Effect |
|-------|--------|
| `cube` | Gentle Y tilt; focused face flatter |
| `threeD` | Y tilt + recede |
| `flip` | Flip while switching; idle tabs upright |
| `coverflow` | Side fans + depth |
| `carousel` | Turntable |
| `cards` | Slight Z tilt + offset |
| `rotate` | X tilt up from the bottom edge |

3D forces item motion to `colorTween` so 2D transforms do not crush the icons. Water-drop ignores 3D.

## Colors

Priority: **shortcut fields > `TabColors` > `ThemeData.colorScheme`**.

| Field | Used for | Fallback |
|-------|----------|----------|
| `background` | Bar fill | `surface` |
| `active` | Selected icon, water-drop filled icon | `primary` |
| `inactive` | Unselected icon | `onSurfaceVariant` |
| `indicator` | Indicator, hanging drip, falling bead, curvedNotch dot | `active` |
| `gradient` | Bar gradient (wins over flat fill) | none |
| `fab` / `fabIcon` | materialNotch FAB | `active` / `onPrimary` |
| `pressed` | Piano press fill | `lerp(background, indicator, 0.55)` |
| `labelActive` / `labelInactive` | Labels | `active` / `inactive` |
| `divider` | sDivider seams | `inactive` 45% |
| `pianoSeam` | sCurve seams | black 8% |
| `shadow` | Elevation | black 26% |
| `ripple` / `glow` / `star` | Ripple / glow / twinkle | `active` (ripple 20%) |
| `TabBadge.color` / `textColor` | Badge | red / white |

## Recipes

**Sliding pill**

```dart
shape: TabBarShape.rounded,
animation: TabAnimationStyle.slideIndicator,
```

**Piano keys**

```dart
shape: TabBarShape.sCurve,
animation: TabAnimationStyle.none,
```

**Water drop (800ms linear)**

```dart
shape: TabBarShape.waterDrop,
animation: TabAnimationStyle.waterDrop,
animationDuration: const Duration(milliseconds: 800),
animationCurve: Curves.linear,
```

**Center FAB cutout**

```dart
shape: TabBarShape.materialNotch,
indicatorAnimation: TabIndicatorStyle.none,
itemAnimation: TabItemAnimation.bounce, // tab animates; FAB stays still
cornerRadius: 32,
```

**Following notch**

```dart
shape: TabBarShape.curvedNotch,
barMotion: TabBarMotion.followNotch,
indicatorAnimation: TabIndicatorStyle.none,
```

**Joined container tab**

```dart
shape: TabBarShape.container,
tabExtent: 48,
```

**Rotate (icon + label 180° then back)**

```dart
animation: TabAnimationStyle.rotate,
```

**3D coverflow**

```dart
enable3D: true,
threeDStyle: Tab3DStyle.coverflow,
```

## Gestures, SafeArea, reduce motion

- **`enableDragSelect`**: horizontal fling on the bar; does not wrap at the ends.
- **`safeArea`**: pads only the edge for `position`.
- **`respectReduceMotion`**: system “disable animations” turns off indicator/3D/bar motion and uses fade on items.
- **`margin`**: outside padding, inside SafeArea.

## Custom bar path

```dart
typedef TabBarPathBuilder = Path Function(
  Size size,
  int selectedIndex,
  int itemCount,
  double progress,
);
```

Coordinates: local to the horizontal bar, origin top-left, y down. Side bars rotate this path after it is built. `progress` is the current switch 0–1.

## Example

```bash
cd example
flutter pub get
flutter run
```

| Page | What it shows |
|------|----------------|
| Regular shapes | Regular outlines |
| Irregular shapes | Convex / `materialNotch` / `curvedNotch` / water drop / moon |
| Container / S-curve | Joined tabs, piano keys; four-edge layout |
| Colors | Water-drop palettes with labels and badges |
| Item shapes | Selected-item clips |
| Surfaces | Four fills |
| Indicator / Item animations | Indicator and item layers |
| 3D switch | 3D styles |
| Badges & external media | Lottie / GIF / custom badges (`lottie` is an example-only dependency) |
| Top / RTL / Reduce motion | Top bar, RTL, reduce-motion |

Android release signing uses `example/jks/` (see `example/jks/README.md`). Gradle reads `example/android/key.properties`.
