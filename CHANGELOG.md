# Changelog

[中文](CHANGELOG-ZH.md)

## 0.2.1

- **Visual:** `container` tab shoulders use Chromium-style outward `arcTo` feet (Chrome tabs); `sCurve` / `sDivider` piano seams use cubic Bezier curves. Public API unchanged.

## 0.2.0

- Depend on standalone [`material_ui`](https://pub.dev/packages/material_ui) `^1.0.1` instead of `package:flutter/material.dart` (requires Dart 3.12 / Flutter 3.44+)
- Fill SafeArea system insets with the bar background so body content does not show through under 3-button navigation (e.g. Galaxy S20). Only the inset *strips* are painted so FAB notch cutouts stay hollow.
- Water-drop no longer forces `feedbackAnimation` off: `starTwinkle` / `moonTwinkle` can run with the drip
- Replace bar shapes `moonIn` / `moonOut` with `moonTwinkle` feedback (crescents twinkle on the selected icon and label, like `starTwinkle`)

## 0.1.0

Initial release of `tab_animation_pro`.

### Shapes

- Regular bars: `fixed`, `rounded`, `squircle`, `floating`, `pill`, `segmented`, `underline`
- Irregular bars: `convexFixed`, `convexReact`, `concave`, `bubble`, `wave`
- `materialNotch`: [animated_bottom_navigation_bar](https://pub.dev/packages/animated_bottom_navigation_bar) cutout. `TabFabLocation` (none / center / outside top-left, top-right, far left, far right), `TabNotchSmoothness` (sharp–verySmooth, notch only for center), FAB tap pop (scale + notch grow); tab taps animate the item only
- `curvedNotch`: softer notch + small disc that follows the selected tab
- `waterDrop`: hanging drip + falling bead aligned with [water_drop_nav_bar](https://pub.dev/packages/water_drop_nav_bar). Labels, icons, and badges stay visible; the top drip remains on the selected tab after the drop lands
- `moonIn` / `moonOut`: crescent cut inward vs bulge outward
- `container`: joined body + protruding selected tab ([tab_container](https://pub.dev/packages/tab_container) style); `tabExtent` / `tabCornerRadius`
- `sCurve` / `sDivider`: interlocking piano keys with S seams. Selected key taps down then rests flush with the others (color crossfade). Hit-testing uses the key path so taps match the silhouette
- `custom` bar path via `customBarPath`
- Positions: `bottom` / `top` / `left` / `right` (side bars rotate the horizontal path)

### Item / surface

- `TabItemShape`: `none`, `circle`, `stadium`, `hexagon`, `diamond`, `trapezoid`, `parallelogram`, `leaf`, `custom`
- `TabBarSurface`: `solid`, `gradient`, `glass`, `neumorphic`. `glass` is liquid frost (live blur + vibrancy + specular rim); the Surfaces demo puts wallpaper behind the bar
- `TabItemShape.none` no longer falls back to a stadium capsule; the selected ellipse is omitted
- Water-drop drip is clipped to the bar path so it does not spill into a smooth FAB notch
- Side `container` bars map the protruding tab to the same slot as the icons (left/right)

### Animations

- Layered APIs: `indicatorAnimation`, `itemAnimation`, `feedbackAnimation`, `barMotion`
- Convenience presets: `TabAnimationStyle`
- `TabItemAnimation.rotate`: icon **and** label spin 180° then settle upright
- `TabIndicatorStyle.waterDrop` / `starTwinkle` and matching presets
- `enable3D` + `Tab3DStyle` (`cube`, `threeD`, `flip`, `coverflow`, `carousel`, `cards`, `rotate`)

### Media & color

- Host-supplied icons/badges via `TabGraphic` / `TabBadge` (no Lottie/GIF dependency)
- Full palette: `TabColors` plus shortcut `backgroundColor` / `activeColor` / `inactiveColor` / `indicatorColor` / `gradient`

### Example

- Full-platform example; Android release signing aligned to swiper_view_pro style
- Demo pages: regular/irregular shapes, container/S-curve, colors, item shapes, surfaces, indicator/item animations, 3D, badges & external media, top/RTL/reduce-motion
