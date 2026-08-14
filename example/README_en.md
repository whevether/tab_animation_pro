# tab_animation_pro_example

Demo app for shapes, animations, 3D switch, and host-supplied icons/badges.

[中文](README.md)

## Run

```bash
cd example
flutter pub get
flutter run
```

## Pages

| Page | What it shows |
|------|----------------|
| Regular shapes | Regular bar outlines |
| Irregular shapes | Convex / notch / `materialNotch` (center FAB cutout) / `curvedNotch` / water drop / moon |
| Container / S-curve | `container` joined tabs; `sCurve` / `sDivider` piano keys (press then rest flush) |
| Colors | Water-drop palette (Teal / Indigo / Rose) with labels and badges |
| Item shapes | Selected-item clip shapes |
| Surfaces | solid / gradient / glass / neumorphic |
| Indicator animations | Indicator layer, including water drop (top drip tracks the selected tab) |
| Item animations | Item motion; `rotate` spins icon + label 180° then settles |
| 3D switch | Toggle `enable3D`; pick cube / threeD / flip / coverflow / carousel / cards / rotate |
| Badges & external media | Host-supplied Lottie/GIF (`lottie` is an example dependency only) |
| Top / RTL / Reduce motion | Top bar, mirrored layout, reduce-motion |

## Android signing

See [jks/README.md](jks/README.md). Gradle reads `android/key.properties`.

```bash
cd example
flutter build apk --release
```

## Dependency

The example depends on the local package via `path: ../`.
