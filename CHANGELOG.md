# Changelog

[中文](CHANGELOG-ZH.md)

## 0.1.0

Initial release of `tab_animation_pro`.

### Shapes

- Regular bars: `fixed`, `rounded`, `squircle`, `floating`, `pill`, `segmented`, `underline`
- Irregular bars: `convexFixed`, `convexReact`, `concave`, `bubble`, `wave`
- `materialNotch`: [animated_bottom_navigation_bar](https://pub.dev/packages/animated_bottom_navigation_bar) cutout. `TabFabLocation` (none / center / end), `TabNotchSmoothness` (sharp–verySmooth), FAB tap pop (scale + notch grow); tab taps animate the item only
- `curvedNotch`: softer notch + small disc that follows the selected tab
- `waterDrop`: hanging drip + falling bead aligned with [water_drop_nav_bar](https://pub.dev/packages/water_drop_nav_bar). Labels, icons, and badges stay visible; the top drip remains on the selected tab after the drop lands
- `moonIn` / `moonOut`: crescent cut inward vs bulge outward
- `container`: joined body + protruding selected tab ([tab_container](https://pub.dev/packages/tab_container) style); `tabExtent` / `tabCornerRadius`
- `sCurve` / `sDivider`: interlocking piano keys with S seams. Selected key taps down then rests flush with the others (color crossfade). Hit-testing uses the key path so taps match the silhouette
- `custom` bar path via `customBarPath`
- Positions: `bottom` / `top` / `left` / `right` (side bars rotate the horizontal path)

### Item / surface

- `TabItemShape`: `none`, `circle`, `stadium`, `hexagon`, `diamond`, `trapezoid`, `parallelogram`, `leaf`, `custom`
- `TabBarSurface`: `solid`, `gradient`, `glass`, `neumorphic`

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
