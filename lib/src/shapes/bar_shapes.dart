import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/enums.dart';

typedef TabBarPathBuilder = Path Function(
  Size size,
  int selectedIndex,
  int itemCount,
  double progress,
);

/// Builds the bar outline path for a [TabBarShape].
Path buildTabBarPath({
  required TabBarShape shape,
  required Size size,
  required int selectedIndex,
  required int itemCount,
  required double progress,
  double cornerRadius = 16,
  double notchRadius = 22,
  double convexHeight = 22,
  double waveAmplitude = 10,
  double tabExtent = 0,
  double tabCornerRadius = 0,
  /// Optional X center for notch / convex-style bumps (defaults to selected slot).
  double? bumpCenterX,
  TabBarPathBuilder? customBuilder,
}) {
  if (shape == TabBarShape.custom && customBuilder != null) {
    return customBuilder(size, selectedIndex, itemCount, progress);
  }

  final w = size.width;
  final h = size.height;
  final count = math.max(itemCount, 1);
  final itemW = w / count;
  final selectedCenter = bumpCenterX ?? (selectedIndex + 0.5) * itemW;

  switch (shape) {
    case TabBarShape.fixed:
    case TabBarShape.underline:
    case TabBarShape.segmented:
      return Path()..addRect(Offset.zero & size);

    case TabBarShape.rounded:
      return Path()
        ..addRRect(
          RRect.fromRectAndCorners(
            Offset.zero & size,
            topLeft: Radius.circular(cornerRadius),
            topRight: Radius.circular(cornerRadius),
          ),
        );

    case TabBarShape.squircle:
      return _squircle(Offset.zero & size, cornerRadius);

    case TabBarShape.floating:
      return Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(8, 4, w - 16, h - 8),
            Radius.circular(cornerRadius),
          ),
        );

    case TabBarShape.pill:
      return Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(12, 6, w - 24, h - 12),
            Radius.circular(h),
          ),
        );

    case TabBarShape.convexFixed:
      return _convexPath(size, w / 2, convexHeight, cornerRadius);

    case TabBarShape.convexReact:
      return _convexPath(size, selectedCenter, convexHeight, cornerRadius);

    case TabBarShape.concave:
      return _concavePath(size, w / 2, convexHeight, cornerRadius);

    case TabBarShape.materialNotch:
      // Fixed center circular cutout (Material BottomAppBar style).
      return _materialNotch(size, bumpCenterX ?? w / 2, notchRadius, cornerRadius);

    case TabBarShape.curvedNotch:
      // Softer, narrower notch that tracks the selected tab.
      return _curvedNotch(size, selectedCenter, notchRadius, cornerRadius);

    case TabBarShape.bubble:
      return _bubblePath(size, selectedCenter, convexHeight + 8, cornerRadius);

    case TabBarShape.wave:
      return _wavePath(size, selectedIndex, count, waveAmplitude, progress);

    case TabBarShape.waterDrop:
      // Flat bar — drip animation is painted by TabIndicatorStyle.waterDrop
      // (water_drop_nav_bar style).
      return Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Offset.zero & size,
            Radius.circular(cornerRadius * 0.35),
          ),
        );

    case TabBarShape.moonIn:
      return _moonPath(
        size,
        selectedCenter,
        cornerRadius,
        inward: true,
      );

    case TabBarShape.moonOut:
      return _moonPath(
        size,
        selectedCenter,
        cornerRadius,
        inward: false,
      );

    case TabBarShape.container:
      return buildContainerTabPath(
        size: size,
        selectedIndex: selectedIndex,
        itemCount: count,
        borderRadius: cornerRadius,
        tabExtent: tabExtent,
        tabBorderRadius: tabCornerRadius,
      );

    case TabBarShape.sCurve:
      // Prefer [buildPianoKeyPaths] from the widget so previousIndex can morph press.
      return buildPianoKeysBarPath(
        size: size,
        selectedIndex: selectedIndex,
        itemCount: count,
        progress: progress,
      );

    case TabBarShape.sDivider:
      return Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Offset.zero & size,
            Radius.circular(cornerRadius),
          ),
        );

    case TabBarShape.custom:
      return Path()..addRect(Offset.zero & size);
  }
}

Path _squircle(Rect rect, double radius) {
  final r = math.min(radius, math.min(rect.width, rect.height) / 2);
  // Approximate continuous corners with a high-radius RRect.
  return Path()
    ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(r * 1.2)));
}

Path _convexPath(Size size, double centerX, double bump, double corner) {
  final w = size.width;
  final h = size.height;
  // Keep the bump inside positive y so it is not clipped by the widget bounds.
  final top = bump;
  final path = Path();
  path.moveTo(0, top + corner);
  path.quadraticBezierTo(0, top, corner, top);
  path.lineTo(centerX - bump * 1.6, top);
  path.cubicTo(
    centerX - bump * 0.6,
    top,
    centerX - bump * 0.7,
    0,
    centerX,
    0,
  );
  path.cubicTo(
    centerX + bump * 0.7,
    0,
    centerX + bump * 0.6,
    top,
    centerX + bump * 1.6,
    top,
  );
  path.lineTo(w - corner, top);
  path.quadraticBezierTo(w, top, w, top + corner);
  path.lineTo(w, h);
  path.lineTo(0, h);
  path.close();
  return path;
}

Path _concavePath(Size size, double centerX, double depth, double corner) {
  final w = size.width;
  final h = size.height;
  final path = Path();
  path.moveTo(0, corner);
  path.quadraticBezierTo(0, 0, corner, 0);
  path.lineTo(centerX - depth * 2, 0);
  path.cubicTo(
    centerX - depth,
    0,
    centerX - depth,
    depth,
    centerX,
    depth,
  );
  path.cubicTo(
    centerX + depth,
    depth,
    centerX + depth,
    0,
    centerX + depth * 2,
    0,
  );
  path.lineTo(w - corner, 0);
  path.quadraticBezierTo(w, 0, w, corner);
  path.lineTo(w, h);
  path.lineTo(0, h);
  path.close();
  return path;
}

Path _materialNotch(Size size, double centerX, double radius, double corner) {
  final w = size.width;
  final h = size.height;
  // Compact circular cradle — sized for a ~32–36 FAB, not a half-bar scoop.
  final host = math.min(radius, math.min(w * 0.12, h * 0.38)).clamp(16.0, 24.0);
  final cx = centerX.clamp(host + corner + 4, w - host - corner - 4);
  final path = Path();
  path.moveTo(0, math.min(corner, h));
  path.quadraticBezierTo(0, 0, corner, 0);
  path.lineTo(cx - host, 0);
  path.arcToPoint(
    Offset(cx + host, 0),
    radius: Radius.circular(host),
    clockwise: true,
  );
  path.lineTo(w - corner, 0);
  path.quadraticBezierTo(w, 0, w, math.min(corner, h));
  path.lineTo(w, h);
  path.lineTo(0, h);
  path.close();
  return path;
}

/// Organic notch: quadratic shoulders + circular cradle that follows selection.
Path _curvedNotch(Size size, double centerX, double radius, double corner) {
  final w = size.width;
  final h = size.height;
  // Wide enough to cradle a compact disc, shallow enough not to swallow the bar.
  final host = math.min(radius, math.min(w * 0.09, 22.0)).clamp(16.0, 22.0);
  final shoulder = host * 0.55;
  final depth = host * 0.72;
  final cx = centerX.clamp(
    host + shoulder + corner + 2,
    w - host - shoulder - corner - 2,
  );

  final path = Path();
  path.moveTo(0, math.min(corner, h));
  path.quadraticBezierTo(0, 0, corner, 0);
  path.lineTo(cx - host - shoulder, 0);
  path.cubicTo(
    cx - host - shoulder * 0.2,
    0,
    cx - host,
    depth * 0.08,
    cx - host * 0.72,
    depth * 0.62,
  );
  path.quadraticBezierTo(cx, depth, cx + host * 0.72, depth * 0.62);
  path.cubicTo(
    cx + host,
    depth * 0.08,
    cx + host + shoulder * 0.2,
    0,
    cx + host + shoulder,
    0,
  );
  path.lineTo(w - corner, 0);
  path.quadraticBezierTo(w, 0, w, math.min(corner, h));
  path.lineTo(w, h);
  path.lineTo(0, h);
  path.close();
  return path;
}

Path _bubblePath(Size size, double centerX, double bump, double corner) {
  return _convexPath(size, centerX, bump, corner);
}

Path _wavePath(
  Size size,
  int selectedIndex,
  int count,
  double amplitude,
  double progress,
) {
  final w = size.width;
  final h = size.height;
  final path = Path();
  path.moveTo(0, amplitude + 4);
  final steps = 40;
  for (var i = 0; i <= steps; i++) {
    final x = w * i / steps;
    final phase = (x / w) * math.pi * count + selectedIndex + progress * math.pi;
    final y = amplitude + math.sin(phase) * amplitude * 0.6;
    path.lineTo(x, y);
  }
  path.lineTo(w, h);
  path.lineTo(0, h);
  path.close();
  return path;
}

/// Crescent moon on the selected slot.
///
/// [inward] true = 往里 cut into the bar; false = 往外 bulge outward.
Path _moonPath(
  Size size,
  double centerX,
  double corner, {
  required bool inward,
}) {
  final w = size.width;
  final h = size.height;
  final r = math.min(corner, h / 2);
  final moonR = math.min(20.0, math.min(w * 0.1, h * 0.42));
  final cx = centerX.clamp(moonR * 1.6 + r, w - moonR * 1.6 - r);

  if (inward) {
    // 往里: crescent bite along the top edge.
    final path = Path();
    path.moveTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
    path.lineTo(cx - moonR * 1.25, 0);
    // Outer rim dips into the bar.
    path.arcToPoint(
      Offset(cx + moonR * 0.35, moonR * 0.95),
      radius: Radius.circular(moonR * 1.2),
      clockwise: true,
    );
    // Inner rim swings back up → classic 🌙 cutout.
    path.arcToPoint(
      Offset(cx + moonR * 1.25, 0),
      radius: Radius.circular(moonR * 0.85),
      clockwise: false,
    );
    path.lineTo(w - r, 0);
    path.quadraticBezierTo(w, 0, w, r);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    return path;
  }

  // 往外: crescent crest rising above the bar top.
  final rise = moonR * 1.2;
  final path = Path();
  path.moveTo(0, rise + r);
  path.quadraticBezierTo(0, rise, r, rise);
  path.lineTo(cx - moonR * 1.3, rise);
  // Outer moon edge up.
  path.arcToPoint(
    Offset(cx + moonR * 0.2, rise - moonR * 1.05),
    radius: Radius.circular(moonR * 1.25),
    clockwise: false,
  );
  // Inner crescent edge back down.
  path.arcToPoint(
    Offset(cx + moonR * 1.3, rise),
    radius: Radius.circular(moonR * 0.9),
    clockwise: true,
  );
  path.lineTo(w - r, rise);
  path.quadraticBezierTo(w, rise, w, rise + r);
  path.lineTo(w, h);
  path.lineTo(0, h);
  path.close();
  return path;
}

/// Classic teardrop path centered at [c], tip pointing up by default.
Path buildTeardropPath(Offset c, double radius, {bool tipUp = true}) {
  final r = radius;
  final path = Path();
  if (tipUp) {
    final tip = Offset(c.dx, c.dy - r * 1.45);
    path.moveTo(tip.dx, tip.dy);
    path.quadraticBezierTo(c.dx - r * 1.1, c.dy - r * 0.1, c.dx - r, c.dy + r * 0.35);
    path.arcToPoint(
      Offset(c.dx + r, c.dy + r * 0.35),
      radius: Radius.circular(r),
      clockwise: false,
    );
    path.quadraticBezierTo(c.dx + r * 1.1, c.dy - r * 0.1, tip.dx, tip.dy);
  } else {
    final tip = Offset(c.dx, c.dy + r * 1.45);
    path.moveTo(tip.dx, tip.dy);
    path.quadraticBezierTo(c.dx - r * 1.1, c.dy + r * 0.1, c.dx - r, c.dy - r * 0.35);
    path.arcToPoint(
      Offset(c.dx + r, c.dy - r * 0.35),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.quadraticBezierTo(c.dx + r * 1.1, c.dy + r * 0.1, tip.dx, tip.dy);
  }
  path.close();
  return path;
}

/// tab_container-style joined shape (TabEdge.top geometry).
///
/// Body is a rounded rect; the selected tab protrudes upward with
/// rounded tab corners and concave quadratic fillets at the join —
/// matching https://pub.dev/packages/tab_container `RenderTabFrame._getPath`.
Path buildContainerTabPath({
  required Size size,
  required int selectedIndex,
  required int itemCount,
  double borderRadius = 16,
  double tabExtent = 0,
  double tabBorderRadius = 0,
  double? indicatorStart,
  double? indicatorEnd,
}) {
  final count = math.max(itemCount, 1);
  final itemW = size.width / count;
  final start = indicatorStart ?? selectedIndex * itemW;
  final end = indicatorEnd ?? (selectedIndex + 1) * itemW;
  return _containerPathFromBounds(
    size,
    start,
    end,
    borderRadius,
    tabExtent: tabExtent,
    tabCorner: tabBorderRadius,
  );
}

Path _containerPathFromBounds(
  Size size,
  double indicatorStart,
  double indicatorEnd,
  double corner, {
  double tabExtent = 0,
  double tabCorner = 0,
}) {
  final w = size.width;
  final h = size.height;
  final extent = tabExtent > 0 ? tabExtent : math.min(36.0, h * 0.42);
  final bodyRadius = math.min(corner, (h - extent) / 2).clamp(0.0, 24.0);
  final tabRadius = tabCorner > 0
      ? math.min(tabCorner, extent / 2)
      : math.min(corner, extent / 2).clamp(4.0, 16.0);

  var start = indicatorStart.clamp(0.0, w);
  var end = indicatorEnd.clamp(0.0, w);
  if (end < start) {
    final t = start;
    start = end;
    end = t;
  }
  if (end - start < tabRadius * 2 + 8) {
    final mid = (start + end) / 2;
    start = (mid - tabRadius - 8).clamp(0.0, w);
    end = (mid + tabRadius + 8).clamp(0.0, w);
  }

  // Port of tab_container TabEdge.bottom path, then flip to TabEdge.top.
  final brx = bodyRadius;
  final blx = bodyRadius;
  final tblx = tabRadius;
  final tbrx = tabRadius;
  final tryY = tabRadius;

  double? critical1;
  double? critical2;
  double? critical3;
  double? critical4;

  final sum1 = brx + tblx;
  if (sum1 > 0 && w - end < sum1) {
    critical1 = brx / sum1 * (w - end);
    critical2 = tblx / sum1 * (w - end);
  }
  final sum2 = tbrx + blx;
  if (sum2 > 0 && start < sum2) {
    critical3 = tbrx / sum2 * start;
    critical4 = blx / sum2 * start;
  }

  final path = Path()
    ..moveTo(0, bodyRadius)
    ..quadraticBezierTo(0, 0, bodyRadius, 0)
    ..lineTo(w - bodyRadius, 0)
    ..quadraticBezierTo(w, 0, w, bodyRadius)
    ..lineTo(w, h - extent - bodyRadius)
    ..quadraticBezierTo(
      w,
      h - extent,
      math.max(w - (critical1 ?? brx), end),
      h - extent,
    )
    ..lineTo(math.min(w, end + (critical2 ?? tblx)), h - extent)
    ..quadraticBezierTo(end, h - extent, end, h - extent + tabRadius)
    ..lineTo(end, h - tryY)
    ..quadraticBezierTo(end, h, end - tabRadius, h)
    ..lineTo(start + tabRadius, h)
    ..quadraticBezierTo(start, h, start, h - tryY)
    ..lineTo(start, h - extent + tabRadius)
    ..quadraticBezierTo(
      start,
      h - extent,
      math.max(0, start - (critical3 ?? tbrx)),
      h - extent,
    )
    ..lineTo(math.min(critical4 ?? blx, start), h - extent)
    ..quadraticBezierTo(0, h - extent, 0, h - extent - bodyRadius)
    ..close();

  // Flip to TabEdge.top: tab protrudes upward.
  return path.transform(
    (Matrix4.identity()
          ..scaleByDouble(1, -1, 1, 1)
          ..translateByDouble(0, -h, 0, 1))
        .storage,
  );
}

/// Dip amount for a piano key. Peaks mid-animation, then returns to 0 so
/// every key rests at the same top height.
double _pianoPressOffset({
  required int index,
  required int selectedIndex,
  required int previousIndex,
  required double easedProgress,
  required double depth,
}) {
  if (index != selectedIndex || selectedIndex == previousIndex) return 0;
  return depth * math.sin(easedProgress * math.pi);
}

/// Piano-key bar: interlocking S-curve side walls between keys.
/// The newly selected key dips then returns so all keys rest at the same height.
Path buildPianoKeysBarPath({
  required Size size,
  required int selectedIndex,
  required int itemCount,
  double progress = 1,
  int previousIndex = 0,
  double bend = 7,
  double pressDepth = 6,
}) {
  final keys = buildPianoKeyPaths(
    size: size,
    selectedIndex: selectedIndex,
    previousIndex: previousIndex,
    itemCount: itemCount,
    progress: progress,
    bend: bend,
    pressDepth: pressDepth,
  );
  final path = Path();
  for (final key in keys) {
    path.addPath(key, Offset.zero);
  }
  return path;
}

/// Individual piano-key outlines (left→right). Useful for per-key fill colors.
List<Path> buildPianoKeyPaths({
  required Size size,
  required int selectedIndex,
  required int itemCount,
  int previousIndex = 0,
  double progress = 1,
  double bend = 7,
  double pressDepth = 6,
}) {
  final w = size.width;
  final h = size.height;
  final n = math.max(itemCount, 1);
  final keyW = w / n;
  final b = math.min(bend, keyW * 0.18).clamp(4.0, 8.0);
  final easeP = Curves.easeInOutCubic.transform(progress.clamp(0.0, 1.0));
  final depth = math.min(pressDepth, h * 0.14);

  const baseTop = 0.0;

  double seamX(int afterIndex, double t) {
    final base = (afterIndex + 1) * keyW;
    final dir = afterIndex.isEven ? 1.0 : -1.0;
    final s = math.sin(t * math.pi);
    return base + dir * b * s;
  }

  final paths = <Path>[];
  for (var i = 0; i < n; i++) {
    final press = _pianoPressOffset(
      index: i,
      selectedIndex: selectedIndex,
      previousIndex: previousIndex,
      easedProgress: easeP,
      depth: depth,
    );
    final bottom = h;
    final keyTop = baseTop + press;
    final path = Path();

    const steps = 18;
    final left0 = i == 0 ? 0.0 : seamX(i - 1, 0);
    final right0 = i == n - 1 ? w : seamX(i, 0);
    path.moveTo(left0, keyTop);
    path.lineTo(right0, keyTop);

    if (i == n - 1) {
      path.lineTo(w, bottom);
    } else {
      for (var s = 1; s <= steps; s++) {
        final t = s / steps;
        path.lineTo(seamX(i, t), keyTop + (bottom - keyTop) * t);
      }
    }

    path.lineTo(i == 0 ? 0.0 : seamX(i - 1, 1), bottom);

    if (i == 0) {
      path.lineTo(0, keyTop);
    } else {
      for (var s = steps - 1; s >= 0; s--) {
        final t = s / steps;
        path.lineTo(seamX(i - 1, t), keyTop + (bottom - keyTop) * t);
      }
    }
    path.close();
    paths.add(path);
  }
  return paths;
}

/// S seams that nest between piano keys (same geometry as [buildPianoKeyPaths]).
List<Path> buildPianoSeamPaths({
  required Size size,
  required int itemCount,
  double bend = 7,
  int selectedIndex = 0,
  int previousIndex = 0,
  double progress = 1,
  double pressDepth = 6,
}) {
  final w = size.width;
  final h = size.height;
  final n = math.max(itemCount, 1);
  if (n < 2) return const [];
  final keyW = w / n;
  final b = math.min(bend, keyW * 0.18).clamp(4.0, 8.0);
  final easeP = Curves.easeInOutCubic.transform(progress.clamp(0.0, 1.0));
  final depth = math.min(pressDepth, h * 0.14);

  double seamX(int afterIndex, double t) {
    final base = (afterIndex + 1) * keyW;
    final dir = afterIndex.isEven ? 1.0 : -1.0;
    return base + dir * b * math.sin(t * math.pi);
  }

  const steps = 18;
  final paths = <Path>[];
  for (var i = 0; i < n - 1; i++) {
    final top = math.max(
      _pianoPressOffset(
        index: i,
        selectedIndex: selectedIndex,
        previousIndex: previousIndex,
        easedProgress: easeP,
        depth: depth,
      ),
      _pianoPressOffset(
        index: i + 1,
        selectedIndex: selectedIndex,
        previousIndex: previousIndex,
        easedProgress: easeP,
        depth: depth,
      ),
    );
    final path = Path();
    path.moveTo(seamX(i, 0), top);
    for (var s = 1; s <= steps; s++) {
      final t = s / steps;
      path.lineTo(seamX(i, t), top + (h - top) * t);
    }
    paths.add(path);
  }
  return paths;
}

/// Rotates a horizontal bar path -90° so the leading edge faces [left]/[right] content.
Path rotateBarPathForSide(Path source, Size horizontalSize) {
  final matrix = Matrix4.identity()
    ..translateByDouble(0, horizontalSize.width, 0, 1)
    ..rotateZ(-math.pi / 2);
  return source.transform(matrix.storage);
}

List<Path> buildSDividerPaths({
  required Size size,
  required int itemCount,
  double bend = 10,
  double inset = 10,
}) {
  final count = math.max(itemCount, 1);
  if (count < 2) return const [];
  final itemW = size.width / count;
  final paths = <Path>[];
  for (var i = 1; i < count; i++) {
    final x = itemW * i;
    final path = Path();
    path.moveTo(x, inset);
    path.cubicTo(
      x + bend,
      size.height * 0.33,
      x - bend,
      size.height * 0.66,
      x,
      size.height - inset,
    );
    paths.add(path);
  }
  return paths;
}

/// Selected item highlight path inside a cell.
Path buildItemShapePath(TabItemShape shape, Rect rect) {
  switch (shape) {
    case TabItemShape.none:
      return Path();
    case TabItemShape.circle:
      final s = math.min(rect.width, rect.height);
      return Path()
        ..addOval(Rect.fromCenter(center: rect.center, width: s, height: s));
    case TabItemShape.stadium:
      return Path()
        ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(rect.height)));
    case TabItemShape.hexagon:
      return _polygon(rect, 6);
    case TabItemShape.diamond:
      return Path()
        ..moveTo(rect.center.dx, rect.top)
        ..lineTo(rect.right, rect.center.dy)
        ..lineTo(rect.center.dx, rect.bottom)
        ..lineTo(rect.left, rect.center.dy)
        ..close();
    case TabItemShape.trapezoid:
      final inset = rect.width * 0.12;
      return Path()
        ..moveTo(rect.left + inset, rect.top)
        ..lineTo(rect.right - inset, rect.top)
        ..lineTo(rect.right, rect.bottom)
        ..lineTo(rect.left, rect.bottom)
        ..close();
    case TabItemShape.parallelogram:
      final skew = rect.width * 0.12;
      return Path()
        ..moveTo(rect.left + skew, rect.top)
        ..lineTo(rect.right, rect.top)
        ..lineTo(rect.right - skew, rect.bottom)
        ..lineTo(rect.left, rect.bottom)
        ..close();
    case TabItemShape.leaf:
      return Path()
        ..moveTo(rect.center.dx, rect.top)
        ..quadraticBezierTo(rect.right, rect.center.dy, rect.center.dx, rect.bottom)
        ..quadraticBezierTo(rect.left, rect.center.dy, rect.center.dx, rect.top)
        ..close();
    case TabItemShape.custom:
      return Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)));
  }
}

Path _polygon(Rect rect, int sides) {
  final path = Path();
  final cx = rect.center.dx;
  final cy = rect.center.dy;
  final r = math.min(rect.width, rect.height) / 2;
  for (var i = 0; i < sides; i++) {
    final a = -math.pi / 2 + i * 2 * math.pi / sides;
    final x = cx + r * math.cos(a);
    final y = cy + r * math.sin(a);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  path.close();
  return path;
}
