# tab_animation_pro

Flutter 多外形 Tab 栏：规则/不规则形状、分层动画、可选 3D，图标与角标由宿主外部传入。兼容 Android、iOS、Web、macOS、Windows、Linux。

[English](README.md)

## 安装

```yaml
dependencies:
  tab_animation_pro: ^0.1.0
```

```bash
flutter pub get
```

## 基本使用

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

## 形状

**栏体：** `fixed` / `rounded` / `squircle` / `floating` / `pill` / `segmented` / `underline` / `convexFixed` / `convexReact` / `concave` / `materialNotch`（居中圆形凹槽 + 固定 FAB） / `curvedNotch`（柔和凹槽 + 圆盘跟随选中项） / `bubble` / `wave` / `waterDrop`（[water_drop_nav_bar](https://pub.dev/packages/water_drop_nav_bar) 悬挂水滴） / `moonIn`（🌙 往里） / `moonOut`（🌙 往外） / `container`（[tab_container](https://pub.dev/packages/tab_container) 风格连体 Tab） / `sCurve`（钢琴键 + 交错 S 边，选中下压） / `sDivider`（钢琴键 + S 缝分割线，选中下压） / `custom`

**位置：** `bottom` / `top` / `left` / `right`

**选中项：** `none` / `circle` / `stadium` / `hexagon` / `diamond` / `trapezoid` / `parallelogram` / `leaf` / `custom`

**材质：** `solid` / `gradient` / `glass` / `neumorphic`

## 动画

可用预设 `TabAnimationStyle`，或细粒度：

- `indicatorAnimation`（`TabIndicatorStyle`）
- `itemAnimation`（`TabItemAnimation`）
- `feedbackAnimation`（`TabFeedbackAnimation`）
- `barMotion`（`TabBarMotion`）

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

## 自定义图标 / 角标（Lottie、GIF 等）

包**不**依赖 Lottie/GIF。由宿主传入：

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

## 配色

所有绘制色都可通过 `colors:`（[TabColors]）或快捷字段传入；未设则回落到主题。

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

| 字段 | 用途 |
|------|------|
| `backgroundColor` / `colors.background` | 栏底 |
| `activeColor` / `colors.active` | 选中图标、水滴实心图标 |
| `inactiveColor` / `colors.inactive` | 未选中图标 |
| `indicatorColor` / `colors.indicator` | 指示器、水滴、curvedNotch 圆点 |
| `colors.fab` / `fabIcon` | materialNotch 圆盘与其上图标 |
| `colors.pressed` | 钢琴键按下填充 |
| `colors.labelActive` / `labelInactive` | 标签文字 |
| `colors.divider` | S 分割线 |
| `colors.shadow` | 阴影 |
| `colors.ripple` / `glow` / `star` | 涟漪、发光、星星 |
| `TabBadge.color` / `textColor` | 角标底与字 |

快捷字段优先于 `colors` 中的同名项。


## 运行示例

```bash
cd example
flutter pub get
flutter run
```

Android release 使用 `example/jks/` 测试证书（见 `example/jks/README.md`）。Gradle 读取 `example/android/key.properties`。
