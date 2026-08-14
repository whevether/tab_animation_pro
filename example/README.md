# tab_animation_pro_example

演示 `tab_animation_pro` 外形、动画、3D 开关与外部图标/角标接入。

[English](README_en.md)

## 运行

```bash
cd example
flutter pub get
flutter run
```

## 演示页

| 页 | 内容 |
|------|------|
| Regular shapes | 规则栏体外形 |
| Irregular shapes | 凸起 / 凹槽 / `materialNotch`（居中 FAB 挖空） / `curvedNotch` / 水滴 / 月亮等 |
| Container / S-curve | `container` 连体 Tab；`sCurve` / `sDivider` 钢琴键（按下后弹回齐平） |
| Colors | 水滴栏换色（Teal / Indigo / Rose），含文字与徽标 |
| Item shapes | 选中项裁剪外形 |
| Surfaces | solid / gradient / glass / neumorphic |
| Indicator animations | 指示器层，含水滴（顶部水滴对准当前 Tab） |
| Item animations | 项动画；`rotate` 为图标+文字转 180° 再归位 |
| 3D switch | 开关 `enable3D`，下拉 cube / threeD / flip / coverflow / carousel / cards / rotate |
| Badges & external media | 宿主传入 Lottie/GIF（example 依赖 `lottie`，包本身不依赖） |
| Top / RTL / Reduce motion | 顶栏、镜像布局、减弱动效 |

## Android 签名

示例 release 打包使用仓库内测试证书，见 [jks/README.md](jks/README.md)。Gradle 读取 `android/key.properties`。

```bash
cd example
flutter build apk --release
```

## 依赖

通过 `path: ../` 引用本地 package。
