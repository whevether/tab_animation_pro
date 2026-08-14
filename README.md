# tab_animation_pro

Flutter tab bar with regular/irregular shapes, layered animations, optional 3D, and externally supplied icons/badges. Works on Android, iOS, Web, macOS, Windows, and Linux.

[中文说明](README-ZH.md)

## Install

```yaml
dependencies:
  tab_animation_pro: ^0.1.0
```

```bash
flutter pub get
```

## Basic usage

```dart
TabAnimationPro(
  items: [
    TabItem(
      label: 'Home',
      icon: TabGraphic.icon(Icons.home_outlined),
      activeIcon: TabGraphic.icon(Icons.home),
      badge: TabBadge.count(3),
    ),
    TabItem(label: 'Search', icon: TabGraphic.icon(Icons.search)),
  ],
  currentIndex: index,
  onTap: (i) => setState(() => index = i),
  shape: TabBarShape.convexReact,
  animation: TabAnimationStyle.slideIndicator,
  enable3D: false,
)
```

## Shapes

**Bar:** `fixed`, `rounded`, `squircle`, `floating`, `pill`, `segmented`, `underline`, `convexFixed`, `convexReact`, `concave`, `materialNotch` (fixed center cradle + FAB), `curvedNotch` (softer notch + disc follows selection), `bubble`, `wave`, `waterDrop` ([water_drop_nav_bar](https://pub.dev/packages/water_drop_nav_bar)-style hanging drip), `moonIn` / `moonOut` (crescent in/out), `container` ([tab_container](https://pub.dev/packages/tab_container)-style joined tabs), `sCurve` (piano keys with interlocking S edges), `sDivider`, `custom`

**Position:** `bottom` / `top` / `left` / `right`

**Item:** `none`, `circle`, `stadium`, `hexagon`, `diamond`, `trapezoid`, `parallelogram`, `leaf`, `custom`

**Surface:** `solid`, `gradient`, `glass`, `neumorphic`

## Animations

Use a preset (`TabAnimationStyle`) or layered APIs:

- `indicatorAnimation` (`TabIndicatorStyle`)
- `itemAnimation` (`TabItemAnimation`)
- `feedbackAnimation` (`TabFeedbackAnimation`)
- `barMotion` (`TabBarMotion`)

## 3D

```dart
TabAnimationPro(
  items: items,
  currentIndex: index,
  onTap: onTap,
  enable3D: true,
  threeDStyle: Tab3DStyle.cube, // cube, threeD, flip, coverflow, carousel, cards, rotate
)
```

## External icons / badges (Lottie, GIF, …)

The package does **not** depend on Lottie or GIF libraries. Pass host widgets:

```dart
TabItem(
  label: 'Home',
  icon: TabGraphic.builder((context, state) {
    return Lottie.asset(
      'assets/home.json',
      animate: state.isSelected && !state.reduceMotion,
    );
  }),
  badge: TabBadge.widget(Image.asset('assets/badge.gif', width: 16, height: 16)),
)
```

## Colors

Every painted color is configurable via `colors:` ([TabColors]) or the shortcut fields. Unset values fall back to the theme.

```dart
TabAnimationPro(
  items: items,
  currentIndex: index,
  onTap: onTap,
  backgroundColor: Colors.white,
  activeColor: Colors.teal,
  inactiveColor: Colors.grey,
  indicatorColor: Colors.teal,
  colors: TabColors(
    fab: Colors.teal,
    fabIcon: Colors.white,
    pressed: Colors.teal.shade100,
    labelActive: Colors.teal,
    labelInactive: Colors.grey,
    divider: Colors.black26,
    shadow: Colors.black26,
    ripple: Colors.teal.withValues(alpha: 0.2),
    glow: Colors.teal,
    star: Colors.amber,
    pianoSeam: Colors.black12,
  ),
)
```

Shortcut fields override the matching [TabColors] entries. Badge fill/text use `TabBadge.color` / `TabBadge.textColor`.


## Example

```bash
cd example
flutter pub get
flutter run
```

Android release signing uses the demo keystore under `example/jks/` (see `example/jks/README.md`). Gradle reads `example/android/key.properties`.
