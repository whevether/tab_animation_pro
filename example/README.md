# tab_animation_pro_example

演示 `tab_animation_pro` 外形、动画、3D 开关与外部图标/角标接入。

[English](README_en.md)

## 运行

```bash
cd example
flutter pub get
flutter run
```

## 操作

| 操作 | 效果 |
|------|------|
| 首页列表 | 进入各形状 / 动画 / 3D / 媒体演示 |
| 3D switch | 开关 `enable3D`，下拉选择 cube / threeD / flip / coverflow / carousel / cards / rotate |
| Badges & external media | 宿主传入 Lottie/GIF（example 依赖 `lottie`，包本身不依赖） |

## Android 签名

示例 release 打包使用仓库内测试证书，见 [jks/README.md](jks/README.md)。Gradle 读取 `android/key.properties`。

```bash
cd example
flutter build apk --release
```

## 依赖

通过 `path: ../` 引用本地 package。
