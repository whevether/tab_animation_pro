# Changelog（中文）

[English](CHANGELOG.md)

## 0.2.0

- 改用独立 [`material_ui`](https://pub.dev/packages/material_ui) `^1.0.1`，不再直接 `import package:flutter/material.dart`（需 Dart 3.12 / Flutter 3.44+）
- SafeArea 系统 inset 用栏背景色填满，避免三键导航机型（如 Galaxy S20）底栏下方内容透出；仅填充 inset **条带**，保留 FAB 缺口镂空
- 水滴模式不再强制关闭 `feedbackAnimation`：可与 `starTwinkle` / `moonTwinkle` 共存
- 移除栏体外形 `moonIn` / `moonOut`，改为 `moonTwinkle` 反馈（月牙在选中图标与文字上闪烁，同 `starTwinkle`）
- **视觉：** `container` 肩部改为 Chromium 同款 `arcTo` 外凸脚（Chrome 标签页）；`sCurve` / `sDivider` 钢琴键缝线为三阶贝塞尔。公开 API 不变。

## 0.1.0

首次发布 `tab_animation_pro`。

### 外形

- 规则栏：`fixed`、`rounded`、`squircle`、`floating`、`pill`、`segmented`、`underline`
- 不规则栏：`convexFixed`、`convexReact`、`concave`、`bubble`、`wave`
- `materialNotch`：对齐 [animated_bottom_navigation_bar](https://pub.dev/packages/animated_bottom_navigation_bar)。`TabFabLocation`（none / center / 栏外左上、右上、最左、最右）、`TabNotchSmoothness`（sharp–verySmooth，仅 center 挖缺口）、点 FAB 弹出（缩放 + 缺口生长）；点 Tab 只播项动画
- `curvedNotch`：柔和凹槽 + 小圆盘跟随选中项
- `waterDrop`：悬挂水滴 + 下落水珠，对齐 [water_drop_nav_bar](https://pub.dev/packages/water_drop_nav_bar)。文字、图标、徽标保持显示；顶部水滴落点后仍对准当前 Tab
- `moonIn` / `moonOut`：🌙 往里切 / 往外鼓
- `container`：连体栏 + 选中项凸起（[tab_container](https://pub.dev/packages/tab_container) 风格）；`tabExtent` / `tabCornerRadius`
- `sCurve` / `sDivider`：交错 S 边钢琴键。选中键按下后弹回，与其它键齐平（颜色交叉淡入）。点击按键轮廓做命中测试
- `custom`：通过 `customBarPath` 自定义栏体路径
- 位置：`bottom` / `top` / `left` / `right`（侧栏将横向路径旋转后使用）

### 选中项 / 材质

- `TabItemShape`：`none`、`circle`、`stadium`、`hexagon`、`diamond`、`trapezoid`、`parallelogram`、`leaf`、`custom`
- `TabBarSurface`：`solid`、`gradient`、`glass`、`neumorphic`。`glass` 为液态毛玻璃（实时模糊 + 饱和 + 高光描边），示例 Surfaces 页用彩色壁纸衬在栏后
- `itemShape: none` 不再回退画胶囊椭圆，选中高亮关闭
- 水滴顶边裁进栏体 Path，平滑 FAB 缺口旁不再溢出去
- 侧栏 `container` 凸起槽与图标上下顺序对齐（left / right）

### 动画

- 分层：`indicatorAnimation`、`itemAnimation`、`feedbackAnimation`、`barMotion`
- 便捷预设：`TabAnimationStyle`
- `TabItemAnimation.rotate`：图标**和**文字一起转 180° 再归位
- `TabIndicatorStyle.waterDrop` / `starTwinkle` 及对应预设
- `enable3D` + `Tab3DStyle`（`cube`、`threeD`、`flip`、`coverflow`、`carousel`、`cards`、`rotate`）

### 媒体与配色

- 图标 / 角标由宿主通过 `TabGraphic` / `TabBadge` 传入（包内无 Lottie/GIF 依赖）
- 完整调色板：`TabColors`，以及快捷字段 `backgroundColor` / `activeColor` / `inactiveColor` / `indicatorColor` / `gradient`

### 示例

- 全平台 example；Android 签名配置对齐 swiper_view_pro 风格
- 演示页：规则/不规则外形、Container/S 曲线、配色、选中项外形、材质、指示器/项动画、3D、徽标与外部媒体、顶栏/RTL/减弱动效
