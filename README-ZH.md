# tab_animation_pro

Flutter 多外形 Tab 栏：规则/不规则形状、分层动画、可选 3D，图标与角标由宿主外部传入。兼容 Android、iOS、Web、macOS、Windows、Linux。

纯 Dart 实现，无平台插件；Lottie / GIF 等由宿主自行依赖并传入。

[English](README.md) · [修改日志](CHANGELOG-ZH.md)

- [安装](#安装)
- [放在哪里](#放在哪里)
- [快速开始](#快速开始)
- [TabAnimationPro 参数](#tabanimationpro-参数)
- [TabItem](#tabitem)
- [图标 TabGraphic](#图标-tabgraphic)
- [徽标 TabBadge](#徽标-tabbadge)
- [TabMediaState](#tabmediastate)
- [控制器](#控制器)
- [栏体外形](#栏体外形)
- [栏体位置](#栏体位置)
- [选中项外形](#选中项外形)
- [材质](#材质)
- [动画](#动画)
- [3D](#3d)
- [配色](#配色)
- [典型组合](#典型组合)
- [手势、安全区、减弱动效](#手势安全区减弱动效)
- [自定义栏体路径](#自定义栏体路径)
- [运行示例](#运行示例)

## 安装

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

## 放在哪里

`TabAnimationPro` 是普通 Widget，最常见是放进 `Scaffold` 的四边槽。`position` 必须与实际槽位一致，侧栏才会把横向路径旋转到正确朝向。

```dart
Scaffold(
  body: pages[index],
  bottomNavigationBar: bar, // position: TabBarPosition.bottom（默认）
  appBar: bar,              // position: TabBarPosition.top
);
```

左右边栏不要塞进 `bottomNavigationBar`（宽度会撑爆）。放在 `body` 的 `Row` 里：

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

右侧同理：`Row(children: [Expanded(...), SizedBox(width: 72, child: bar)])`，`position: TabBarPosition.right`。

## 快速开始

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

选中态由你持有：`onTap` 里改 `index`，再传回 `currentIndex`。未传 `controller` 时，栏会在 `currentIndex` 变化时播放切换动画。

## TabAnimationPro 参数

| 参数 | 类型 | 默认 | 说明 |
|------|------|------|------|
| `items` | `List<TabItem>` | 必填 | Tab 列表。建议 2–5 个；`materialNotch` 建议偶数。 |
| `currentIndex` | `int` | `0` | 当前选中下标。传入 `controller` 时，点击走 `controller.jumpTo`，仍应用 `currentIndex` 做初始值。 |
| `onTap` | `ValueChanged<int>?` | `null` | 点击回调。水滴动画播放中会忽略再次点击。 |
| `controller` | `TabAnimationController?` | `null` | 编程切 Tab。非空时点击不再用 `setState(currentIndex)`，而是 `controller.jumpTo`。 |
| `shape` | `TabBarShape` | `fixed` | 整栏轮廓。 |
| `itemShape` | `TabItemShape` | `none` | 选中槽高亮外形。`none` 不画椭圆。`container` / 钢琴键 / notch / 水滴会关掉独立指示器。 |
| `surface` | `TabBarSurface` | `solid` | 填充材质。 |
| `animation` | `TabAnimationStyle?` | `null` | 一键预设（指示器+项+反馈+栏体运动）。未设时默认指示器 `slidingPill`、项 `colorTween`。 |
| `indicatorAnimation` | `TabIndicatorStyle?` | `null` | 覆盖预设的指示器。 |
| `itemAnimation` | `TabItemAnimation?` | `null` | 覆盖预设的项动画。`enable3D` 时强制 `colorTween`，避免 2D/3D 叠变换。水滴模式强制 `none`。 |
| `feedbackAnimation` | `TabFeedbackAnimation?` | `null` | 覆盖预设的点击反馈。水滴模式强制 `none`。 |
| `barMotion` | `TabBarMotion?` | `null` | 覆盖预设的栏体路径运动。 |
| `enable3D` | `bool` | `false` | 对每项施加透视变换。水滴模式自动关闭。 |
| `threeDStyle` | `Tab3DStyle` | `flip` | 3D 样式。 |
| `perspective` | `double` | `0.0008` | 透视强度，内部夹到 `0.0002–0.0015`。 |
| `spring` | `TabSpringConfig` | stiffness 120 / damping 14 / mass 1 | 预留给过冲/液体类过渡。 |
| `respectReduceMotion` | `bool` | `true` | 为 true 时遵循 `MediaQuery.disableAnimations`：指示器改 `none`，项改 `fade`，栏体运动改 `none`，关掉 3D。 |
| `enableDragSelect` | `bool` | `false` | 在栏上水平快滑（速度绝对值 > 200）切到相邻 Tab。 |
| `position` | `TabBarPosition` | `bottom` | 栏所在边，影响路径旋转与 SafeArea。 |
| `height` | `double` | `64` | 栏厚。侧栏时这是横截面厚度。`minimizeOnScroll` 收起时缩到 55%。 |
| `backgroundColor` | `Color?` | 主题 | 快捷栏底色，覆盖 `colors.background`。 |
| `activeColor` | `Color?` | 主题 primary | 快捷选中色，覆盖 `colors.active`。 |
| `inactiveColor` | `Color?` | 主题 onSurfaceVariant | 快捷未选中色。 |
| `indicatorColor` | `Color?` | 等于 active | 指示器 / 水滴 / curvedNotch 圆点。 |
| `colors` | `TabColors` | 空 | 完整调色板。 |
| `gradient` | `Gradient?` | `null` | 快捷渐变，覆盖 `colors.gradient`；有渐变时优先生效。 |
| `elevation` | `double` | `8` | 阴影高度。钢琴键会夹到 0–8。 |
| `cornerRadius` | `double` | `16` | 栏角。`materialNotch` 用约 `32` 更接近参考包。 |
| `tabExtent` | `double?` | 约 `height * 42%`（36–56） | 仅 `container`：凸起条高度。 |
| `tabCornerRadius` | `double?` | 等于 `cornerRadius` | 仅 `container`：凸起条圆角。 |
| `margin` | `EdgeInsetsGeometry` | `zero` | 栏外边距。 |
| `animationDuration` | `Duration` | 360ms | 切换时长。水滴建议 **800ms**。 |
| `animationCurve` | `Curve` | `easeOutCubic` | 切换曲线。水滴必须用 **`Curves.linear`**（内部用水滴原始 0–1，不再套曲线）。 |
| `showLabels` | `bool` | `true` | 是否画 `TabItem.label`。水滴同样生效。 |
| `customBarPath` | `TabBarPathBuilder?` | `null` | `shape: custom` 时的路径。 |
| `safeArea` | `bool` | `true` | 按 `position` 只垫对应边（底栏垫 bottom，顶栏垫 top，侧栏垫 left/right）。 |
| `fabConfig` | `TabFabConfig` | center + verySmoothEdge | FAB。`container` / `sCurve` / `sDivider` 忽略。仅 `center` 挖圆形缺口并让 Tab 让位；`topLeft` / `topRight` / `left` / `right` 在栏外。 |

## TabItem

```dart
TabItem(
  icon: TabGraphic.icon(Icons.home_outlined),
  activeIcon: TabGraphic.icon(Icons.home), // 可选；未设则一直用 icon
  label: 'Home',
  badge: TabBadge.count(3),
  semanticLabel: '首页', // 无障碍；默认用 label
)
```

| 字段 | 说明 |
|------|------|
| `icon` | 未选中（或唯一）图形，必填。 |
| `activeIcon` | 选中图形。水滴模式用它做实心揭示，未设则回落到 `icon`。 |
| `label` | 图标下方文字。`showLabels: false` 时不画。 |
| `badge` | 叠在项内容右上的徽标。 |
| `semanticLabel` | `Semantics` 标签。 |

## 图标 TabGraphic

包内不依赖 Lottie / 网络图库。四种构造：

```dart
TabGraphic.icon(Icons.search, size: 24);           // 颜色跟栏的 active/inactive 走
TabGraphic.image(AssetImage('assets/tab.png'));    // 可用 color 染色
TabGraphic.widget(MyLottieIcon());                 // 任意 Widget，限制在 size×size
TabGraphic.builder((context, state) {
  return Lottie.asset(
    'assets/home.json',
    animate: state.isSelected && !state.reduceMotion,
  );
});
```

| 工厂 | 行为 |
|------|------|
| `icon` | `Icon`；切换时由栏传入 `tint`（选中插值到 `activeColor`）。 |
| `image` | `Image`，`fit: contain`，`gaplessPlayback: true`。 |
| `widget` | 包进 `SizedBox(size×size)`，栏不再染色。 |
| `builder` | 每帧用 `TabMediaState` 重建，适合 Lottie / GIF。 |

`size` 默认 `24`。水滴揭示圈按该尺寸计算。

## 徽标 TabBadge

叠在图标+文字的 `Stack` 上（`clip: none`），默认偏右上。

```dart
TabBadge.dot();
TabBadge.count(12);          // >99 显示 99+
TabBadge.text('NEW');
TabBadge.widget(Image.asset('assets/badge.gif', width: 16, height: 16));
TabBadge.builder((context, state) {
  return Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(
      color: state.isSelected ? Colors.teal : Colors.red,
      shape: BoxShape.circle,
    ),
  );
});
```

共用参数：`color`、`textColor`、`alignment`（默认 `topRight`）、`offset`（默认 `Offset(4, -4)`）、`size`。

可见性：`count == 0` 或空字符串视为隐藏；`dot` / `widget` / `builder` 始终可见。

`feedbackAnimation: badgePop` 时，选中项徽标会随进度轻微缩放。

## TabMediaState

`TabGraphic.builder` / `TabBadge.builder` 以及子树里的 `TabMediaScope.of(context)` 都能读到：

| 字段 | 含义 |
|------|------|
| `index` | 该项下标 |
| `isSelected` | 是否当前选中 |
| `reduceMotion` | 是否处于减弱动效 |
| `animation` | 该项过渡进度 0–1（未选中一般为 0） |

```dart
final state = TabMediaScope.of(context);
```

## 控制器

```dart
final controller = TabAnimationController(initialIndex: 0);

TabAnimationPro(
  items: items,
  controller: controller,
  onTap: (i) => setState(() {}), // 仍建议刷新宿主页面
);

controller.jumpTo(2);           // 通知栏播放切换
controller.animateTo(2);        // 目前等价于 jumpTo（动画由栏持有）
controller.next(itemCount: items.length);
controller.previous(itemCount: items.length);
```

传入 `controller` 后，点击会 `jumpTo` 而不是改 `currentIndex`。宿主需 `addListener` 或在 `onTap` 里 `setState`，才能刷新页面内容。

未传 `controller` 时，外部改 `currentIndex` 会触发同样的切换动画。

## 栏体外形

`shape` 决定整栏 `Path`。部分外形会占用指示器层（不再画 `slidingPill` 等）。

### 规则

| 值 | 外观 |
|----|------|
| `fixed` | 直角矩形 |
| `rounded` | 顶角圆角（`cornerRadius`） |
| `squircle` | 更大半径的连续圆角近似 |
| `floating` | 内缩圆角条，四周留白 |
| `pill` | 高度方向全圆角胶囊 |
| `segmented` | 直角分段底 |
| `underline` | 扁条，配合线型指示器 |

### 凸起 / 波浪

| 值 | 外观 | 建议 |
|----|------|------|
| `convexFixed` | 中心固定凸起 | 凸起占用栏上方空间 |
| `convexReact` | 凸起跟随选中项 | |
| `concave` | 顶边中心下凹（无 FAB 孔） | |
| `bubble` | 更圆的凸起 | |
| `wave` | 顶边正弦波；`waveTravel` 可让波相位随进度走 | |

### materialNotch

对齐 [animated_bottom_navigation_bar](https://pub.dev/packages/animated_bottom_navigation_bar) 的挖空 FAB。`fabConfig` 在**除 `container` / `sCurve` / `sDivider` 外的所有外形**上都可用（含水滴）；只有 `center` 会挖缺口。

| 效果 | 怎么开 |
|------|--------|
| 无 FAB | `TabFabLocation.none` |
| 居中停靠 | `TabFabLocation.center`：挖缺口，Tab 从中间让位 |
| 栏外左上 / 右上 | `TabFabLocation.topLeft` / `topRight` |
| 栏外最左 / 最右 | `TabFabLocation.left` / `right` |
| 缺口平滑 | `TabNotchSmoothness`：`sharpEdge` / `defaultEdge` / `softEdge` / `smoothEdge` / `verySmoothEdge`（仅 `center` 时，平顶栏 / 水滴 / materialNotch 会挖缺口） |
| 点 FAB 弹出 | 默认 `animateOnTap: true`：缩放；`center` 时缺口从 0 长出 |
| 点 Tab | 只播该项 `itemAnimation`，FAB 不跟着颤 |

- FAB 默认直径 56，缺口边距 8；`center` 时圆心在栏顶边（一半露出）
- 只有 `center` 会拆开 Tab（空隙在中间）。**center 建议偶数个** Tab
- 栏外四位置不挖缺口、不拆 Tab
- 挖空露出的是 Scaffold 背景，需与栏底有对比
- 圆角建议 `cornerRadius: 32`
- `onTap` 点的是 Tab；FAB 走 `fabConfig.onTap`

```dart
TabAnimationPro(
  items: items, // 4 项
  currentIndex: index,
  onTap: onTap,
  shape: TabBarShape.materialNotch,
  animation: TabAnimationStyle.bounce,
  indicatorAnimation: TabIndicatorStyle.none,
  cornerRadius: 32,
  colors: TabColors(fab: Colors.teal, fabIcon: Colors.white),
  fabConfig: TabFabConfig(
    location: TabFabLocation.center, // none / center / topLeft / topRight / left / right
    smoothness: TabNotchSmoothness.verySmoothEdge,
    onTap: () { /* FAB 点击 */ },
  ),
)
```

### curvedNotch

更浅的凹槽 + 顶部小圆点跟随选中项。请设 `barMotion: TabBarMotion.followNotch`，否则凹槽不跟着走。

```dart
shape: TabBarShape.curvedNotch,
barMotion: TabBarMotion.followNotch,
indicatorAnimation: TabIndicatorStyle.none,
itemAnimation: TabItemAnimation.colorTween,
```

### waterDrop

悬挂水滴 + 下落水珠，对齐 [water_drop_nav_bar](https://pub.dev/packages/water_drop_nav_bar)。

- **文字 / 图标 / 徽标都显示**；内容靠下，给顶部水滴留空
- 顶部水滴滑到目标 Tab 后**保持停在该 Tab 上方**
- 选中图标用圆形揭示（outline → filled）；请提供成对的 `icon` / `activeIcon`
- 时长 **800ms** + **`Curves.linear`**
- 动画过程中忽略点击
- 栏底色与水滴色（`indicatorColor`）必须不同，否则看不出垂滴
- 水平栏才画水滴；侧栏仍显示图标文字，不画滴
- 可用 `fabConfig` 加 FAB；仅 `center` 会让 Tab 让位并挖缺口，水滴落点跟槽位对齐；栏外位置不拆 Tab

```dart
TabAnimationPro(
  items: items,
  currentIndex: index,
  onTap: onTap,
  shape: TabBarShape.waterDrop,
  animation: TabAnimationStyle.waterDrop,
  animationDuration: const Duration(milliseconds: 800),
  animationCurve: Curves.linear,
  elevation: 0,
  cornerRadius: 0,
  showLabels: true,
  backgroundColor: Colors.white,
  indicatorColor: Colors.teal, // 与栏底、页面背景都要有对比
  fabConfig: const TabFabConfig(location: TabFabLocation.center),
)
```

只用水滴指示器、栏体用别的外形时：`indicatorAnimation: TabIndicatorStyle.waterDrop`，并同样使用 800ms linear。

### moonIn / moonOut

选中槽上的月牙：`moonIn` 往里切，`moonOut` 往外鼓。

### container

[tab_container](https://pub.dev/packages/tab_container) 风格：栏体连成一块，选中段凸起，两侧 S 肩衔接。凸起高度 `tabExtent`（默认约栏高 42%，夹在 36–56），凸起圆角 `tabCornerRadius`。

```dart
shape: TabBarShape.container,
tabExtent: 48,
tabCornerRadius: 16,
barMotion: TabBarMotion.none,
```

切换时凸起条在 Tab 之间插值平移。

### sCurve / sDivider

交错 S 边钢琴键。

- 选中键**按下再弹回**，静止时与其它键**顶边齐平**
- 选中填充用 `colors.pressed` 交叉淡入
- `sCurve` 画填色键 + 浅缝；`sDivider` 缝更明显（`colors.divider`）
- 点击按 **Path.contains** 命中，对得上歪斜的 S 边
- 示例里钢琴键常用 `animation: TabAnimationStyle.none`，避免项弹跳和按键抢戏

```dart
shape: TabBarShape.sCurve, // 或 sDivider
animation: TabAnimationStyle.none,
colors: TabColors(pressed: Colors.teal.shade100, pianoSeam: Colors.black12),
```

### custom

```dart
shape: TabBarShape.custom,
customBarPath: (size, selectedIndex, itemCount, progress) {
  return Path()..addRRect(
    RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
  );
},
```

签名：`Path Function(Size size, int selectedIndex, int itemCount, double progress)`。

## 栏体位置

| 值 | 用途 |
|----|------|
| `bottom` | `Scaffold.bottomNavigationBar` |
| `top` | 顶栏；SafeArea 垫 top |
| `left` / `right` | 侧栏。横向 Path 旋转 -90°；`right` 再镜像，使凸起朝向内容 |

侧栏请给有限宽度（`SizedBox(width: height)` 一类），不要放进无限宽的 `Row` 子项。

## 选中项外形

`itemShape` 画在指示器层，给选中槽裁一个几何高亮（胶囊、六边形等）。**`none` 不画这层高亮**（没有选中椭圆）。下列栏体外形本来就不会画这层，以免和自身 Path / FAB / 水滴打架：`container`、`sCurve`、`sDivider`、`materialNotch`、`curvedNotch`、`waterDrop`。

| 值 | 说明 |
|----|------|
| `none` | 不画选中槽高亮（不要椭圆） |
| `circle` / `stadium` | 圆 / 胶囊 |
| `hexagon` / `diamond` / `trapezoid` / `parallelogram` / `leaf` | 多边形 |
| `custom` | 预留 |

## 材质

| 值 | 说明 |
|----|------|
| `solid` | 纯色 `background` |
| `gradient` | `colors.gradient` 或快捷 `gradient` |
| `glass` | 液态毛玻璃：实时模糊 + Rec. 709 饱和 + 高光描边（需 `extendBody` 让内容衬在栏后） |
| `neumorphic` | 新拟态高光/阴影 |

## 动画

四层可组合。解析顺序：

1. 若设置了 `animation`，先展开为预设
2. `indicatorAnimation` / `itemAnimation` / `feedbackAnimation` / `barMotion` 逐项覆盖
3. 未设 `animation` 时，缺省指示器 `slidingPill`、项 `colorTween`
4. `shape == waterDrop` 时指示器强制 `waterDrop`（除非减弱动效）

### 预设 `TabAnimationStyle`

| 预设 | 指示器 | 项 | 反馈 | 栏体运动 |
|------|--------|----|------|----------|
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

### 指示器 `TabIndicatorStyle`

| 值 | 效果 |
|----|------|
| `none` | 不画独立指示器 |
| `slidingPill` | 胶囊滑到选中项 |
| `slideLine` | 底边细线平移 |
| `worm` | 弹性伸缩下划线 |
| `snake` | 粗条蠕动填充 |
| `topSweep` | 顶边指示条扫过 |
| `bubblePop` | 图标后圆形气泡 |
| `dot` / `floatingDot` | 圆点 / 略浮起的圆点 |
| `inkDrop` | 墨水扩散 |
| `gradientSpotlight` | 渐变光斑 |
| `waterDrop` | 见水滴外形 |
| `starTwinkle` | 星星闪烁（配合 feedback） |
| `liquidBlob` / `liquidMorph` | 液态斑块 |
| `chipExpand` | 芯片式展开 |
| `custom` | 预留 |

### 项 `TabItemAnimation`

作用在图标上；有 label 时多数会和下方文字组成 `Column`。

| 值 | 效果 |
|----|------|
| `none` / `colorTween` / `custom` | 无变换（颜色仍由 tint 插值） |
| `fade` | 透明度 |
| `scale` | 缩放 |
| `bounce` | 正弦弹跳缩放 |
| `flip` | Y 轴翻面（带轻微透视） |
| `rotate` | **图标和文字一起**转 180° 再归位（`0° → 180° → 0°`） |
| `shift` | 上移 6px |
| `labelReveal` / `flashy` | 上移；选中项文字加粗（未选中文字仍可见） |
| `iconMorph` | 透明过渡（配合 `activeIcon`） |
| `slidingClipped` | 高度裁切 |
| `squeezeStretch` | 横向拉、纵向压 |
| `parallax` | 相对选中项的水平错位 |
| `pulse` | 持续轻微缩放 |
| `wiggle` | 持续轻微摆动 |

`showLabels: true` 时所有项的文字都显示；选中项加粗。`shift` / `labelReveal` / `flashy` 只上移图标，不再把未选中文字透明度打到 0。

### 反馈 `TabFeedbackAnimation`

| 值 | 效果 |
|----|------|
| `none` | 无 |
| `ripple` | InkWell 涟漪（`colors.ripple`） |
| `glow` / `neonPulse` | 图标光晕（`colors.glow`） |
| `elasticPop` | 点击触觉 |
| `badgePop` | 选中项徽标缩放 |
| `haptic` | 仅触觉 |
| `starTwinkle` | 星星粒子（`colors.star`） |

### 栏体 `TabBarMotion`

| 值 | 效果 |
|----|------|
| `none` | 路径不随进度变形（钢琴键仍用进度做按压） |
| `followNotch` | `curvedNotch` 凹槽跟随选中项 |
| `waveTravel` | 波浪相位随进度 |
| `blobFollow` | 液态斑跟随 |
| `minimizeOnScroll` | 收到向上滚动通知时栏高缩到 55%，向下滚恢复 |

`minimizeOnScroll` 的 `NotificationListener` 包在栏自己身上。放在 `Scaffold.bottomNavigationBar` 时**收不到** body 里 ListView 的通知。若要滚动收起，把栏放到滚动视图的祖先（例如 `body` 里 `Column`/`Stack`），或自己听滚动再改 `height`。

## 3D

```dart
enable3D: true,
threeDStyle: Tab3DStyle.coverflow,
perspective: 0.0008,
```

| 值 | 效果 |
|----|------|
| `cube` | 邻项绕 Y 轻转，选中面更正 |
| `threeD` | Y 转 + 后移 |
| `flip` | 切入/切出时翻面，静止直立 |
| `coverflow` | 两侧打开 + 纵深 |
| `carousel` | 转盘 |
| `cards` | 轻微 Z 转 + 错位 |
| `rotate` | 绕 X 从底边抬起 |

开启后项动画改为 `colorTween`，避免和透视矩阵叠在一起压扁图标。水滴模式忽略 3D。

## 配色

解析优先级：**快捷字段 > `TabColors` > `ThemeData.colorScheme`**。

```dart
TabAnimationPro(
  items: items,
  currentIndex: index,
  onTap: onTap,
  backgroundColor: Colors.white,
  activeColor: Colors.teal,
  inactiveColor: Colors.grey,
  indicatorColor: Colors.teal,
  gradient: null,
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

| 字段 | 用途 | 回落 |
|------|------|------|
| `background` | 栏底 | `ColorScheme.surface` |
| `active` | 选中图标、水滴实心图标 | `primary` |
| `inactive` | 未选中图标 | `onSurfaceVariant` |
| `indicator` | 指示器、悬挂水滴、下落水珠、curvedNotch 点 | `active` |
| `gradient` | 栏渐变（覆盖纯色底） | 无 |
| `fab` / `fabIcon` | materialNotch FAB | `active` / `onPrimary` |
| `pressed` | 钢琴键按下填充 | `lerp(background, indicator, 0.55)` |
| `labelActive` / `labelInactive` | 标签 | `active` / `inactive` |
| `divider` | sDivider 缝 | `inactive` 45% |
| `pianoSeam` | sCurve 缝 | 黑 8% |
| `shadow` | 阴影 | 黑 26% |
| `ripple` / `glow` / `star` | 涟漪 / 光晕 / 星星 | `active`（涟漪 20%） |
| `TabBadge.color` / `textColor` | 角标 | 红底白字 |

## 典型组合

**滑动胶囊**

```dart
shape: TabBarShape.rounded,
animation: TabAnimationStyle.slideIndicator,
```

**钢琴键**

```dart
shape: TabBarShape.sCurve,
animation: TabAnimationStyle.none,
```

**水滴（务必线性 800ms）**

```dart
shape: TabBarShape.waterDrop,
animation: TabAnimationStyle.waterDrop,
animationDuration: const Duration(milliseconds: 800),
animationCurve: Curves.linear,
```

**居中 FAB 挖空**

```dart
shape: TabBarShape.materialNotch,
indicatorAnimation: TabIndicatorStyle.none,
itemAnimation: TabItemAnimation.bounce,
cornerRadius: 32,
fabConfig: const TabFabConfig(
  location: TabFabLocation.center,
  smoothness: TabNotchSmoothness.verySmoothEdge,
),
```

**跟随凹槽**

```dart
shape: TabBarShape.curvedNotch,
barMotion: TabBarMotion.followNotch,
indicatorAnimation: TabIndicatorStyle.none,
```

**连体 Tab**

```dart
shape: TabBarShape.container,
tabExtent: 48,
```

**旋转项（图标+文字 180° 归位）**

```dart
animation: TabAnimationStyle.rotate,
// 或 itemAnimation: TabItemAnimation.rotate
```

**3D Coverflow**

```dart
enable3D: true,
threeDStyle: Tab3DStyle.coverflow,
```

## 手势、安全区、减弱动效

- **`enableDragSelect`**：在栏上水平快滑切相邻项（不循环到尽头之外）。
- **`safeArea`**：只垫 `position` 对应那一边，避免底栏再垫 top。
- **`respectReduceMotion`**：系统关闭动画时，指示器/3D/栏体运动关掉，项改为 fade。
- **`margin`**：整栏外边距，加在 SafeArea 内侧。

## 自定义栏体路径

```dart
typedef TabBarPathBuilder = Path Function(
  Size size,
  int selectedIndex,
  int itemCount,
  double progress,
);
```

坐标系：水平栏为栏的局部坐标，原点在左上，y 向下。侧栏会把这条横向路径旋转后再画。`progress` 为当前切换 0–1。

## 运行示例

```bash
cd example
flutter pub get
flutter run
```

| 页 | 内容 |
|------|------|
| Regular shapes | 规则外形 |
| Irregular shapes | 凸起 / `materialNotch` / `curvedNotch` / 水滴 / 月亮 |
| Container / S-curve | 连体 Tab、钢琴键；可切四边位置 |
| Colors | 水滴换色（含文字与徽标） |
| Item shapes | 选中项裁剪 |
| Surfaces | 四种材质 |
| Indicator / Item animations | 指示器层、项动画 |
| 3D switch | 3D 样式 |
| Badges & external media | Lottie / GIF / 自定义徽标（example 才依赖 `lottie`） |
| Top / RTL / Reduce motion | 顶栏、RTL、减弱动效 |

Android release 使用 `example/jks/` 测试证书（见 `example/jks/README.md`）。Gradle 读取 `example/android/key.properties`。
