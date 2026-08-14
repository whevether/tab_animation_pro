import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/enums.dart';

/// Rec. 709 luma-preserving saturation (s = 1.4). Applied to the backdrop
/// after blur — the shader-free liquid-glass vibrancy recipe.
const _kRec709Vibrancy = <double>[
  1.3150, -0.2861, -0.0289, 0, 0,
  -0.0850, 1.1139, -0.0289, 0, 0,
  -0.0850, -0.2861, 1.3711, 0, 0,
  0, 0, 0, 1, 0,
];

ImageFilter _glassBackdropFilter() {
  final blur = ImageFilter.blur(sigmaX: 28, sigmaY: 28, tileMode: TileMode.clamp);
  return ImageFilter.compose(
    inner: blur,
    outer: const ColorFilter.matrix(_kRec709Vibrancy),
  );
}

/// Paints the tab bar background according to [TabBarSurface].
class TabBarSurfacePainter extends StatelessWidget {
  const TabBarSurfacePainter({
    super.key,
    required this.path,
    required this.surface,
    required this.color,
    this.gradient,
    this.shadowColor = Colors.black26,
    this.elevation = 8,
    this.clipChild = false,
    required this.child,
  });

  final Path path;
  final TabBarSurface surface;
  final Color color;
  final Gradient? gradient;
  final Color shadowColor;
  final double elevation;

  /// When true, clips [child] to [path]. Keep false for notch FAB overlays.
  final bool clipChild;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (surface == TabBarSurface.glass) {
      return _LiquidGlassSurface(
        path: path,
        color: color,
        shadowColor: shadowColor,
        elevation: elevation,
        clipChild: clipChild,
        child: child,
      );
    }

    Widget painted = CustomPaint(
      painter: _SurfacePainter(
        path: path,
        surface: surface,
        color: color,
        gradient: gradient,
        shadowColor: shadowColor,
        elevation: elevation,
      ),
      child: child,
    );

    if (clipChild) {
      painted = ClipPath(clipper: _PathClipper(path), child: painted);
    }
    return painted;
  }
}

/// Frosted liquid-glass platter: blur the live backdrop, boost saturation,
/// then overlay a thin tint + specular rim. Needs content behind the bar
/// (`Scaffold.extendBody: true`) or the frost has nothing to sample.
class _LiquidGlassSurface extends StatelessWidget {
  const _LiquidGlassSurface({
    required this.path,
    required this.color,
    required this.shadowColor,
    required this.elevation,
    required this.clipChild,
    required this.child,
  });

  final Path path;
  final Color color;
  final Color shadowColor;
  final double elevation;
  final bool clipChild;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget content = child;
    if (clipChild) {
      content = ClipPath(clipper: _PathClipper(path), child: content);
    }

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        CustomPaint(
          painter: _GlassShadowPainter(
            path: path,
            color: shadowColor,
            elevation: elevation,
          ),
        ),
        ClipPath(
          clipper: _PathClipper(path),
          child: BackdropFilter(
            filter: _glassBackdropFilter(),
            child: const SizedBox.expand(),
          ),
        ),
        CustomPaint(
          painter: _GlassOverlayPainter(path: path, color: color),
        ),
        content,
      ],
    );
  }
}

class _PathClipper extends CustomClipper<Path> {
  _PathClipper(this.path);
  final Path path;

  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(covariant _PathClipper oldClipper) => oldClipper.path != path;
}

class _GlassShadowPainter extends CustomPainter {
  _GlassShadowPainter({
    required this.path,
    required this.color,
    required this.elevation,
  });

  final Path path;
  final Color color;
  final double elevation;

  @override
  void paint(Canvas canvas, Size size) {
    if (elevation <= 0) return;
    canvas.drawShadow(
      path,
      color.withValues(alpha: 0.32),
      elevation.clamp(6, 18),
      true,
    );
  }

  @override
  bool shouldRepaint(covariant _GlassShadowPainter oldDelegate) {
    return oldDelegate.path != path ||
        oldDelegate.color != color ||
        oldDelegate.elevation != elevation;
  }
}

class _GlassOverlayPainter extends CustomPainter {
  _GlassOverlayPainter({required this.path, required this.color});

  final Path path;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = path.getBounds();
    if (bounds.isEmpty) return;

    // Thin tint — keep the frosted backdrop visible.
    final tintAlpha = color.a < 1 ? color.a.clamp(0.12, 0.38) : 0.22;
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..color = color.withValues(alpha: tintAlpha),
    );

    canvas.save();
    canvas.clipPath(path);

    // Thickness / lighting: bright catch on the top-left, slight falloff below.
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.42),
            Colors.white.withValues(alpha: 0.06),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.08),
          ],
          stops: const [0.0, 0.28, 0.62, 1.0],
        ).createShader(bounds),
    );

    // Specular strip along the top edge (thick-glass highlight).
    canvas.drawRect(
      Rect.fromLTWH(bounds.left, bounds.top, bounds.width, bounds.height * 0.38),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.38),
            Colors.white.withValues(alpha: 0.0),
          ],
        ).createShader(
          Rect.fromLTWH(
            bounds.left,
            bounds.top,
            bounds.width,
            bounds.height * 0.38,
          ),
        ),
    );

    // Edge-lit Fresnel rim (inner stroke, clipped so it sits on the glass).
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.92),
            Colors.white.withValues(alpha: 0.22),
            const Color(0xFFA5F3FC).withValues(alpha: 0.28),
            Colors.white.withValues(alpha: 0.12),
          ],
        ).createShader(bounds),
    );
    canvas.restore();

    // Outer hairline so the platter separates from the wallpaper.
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9
        ..color = Colors.white.withValues(alpha: 0.5),
    );
  }

  @override
  bool shouldRepaint(covariant _GlassOverlayPainter oldDelegate) {
    return oldDelegate.path != path || oldDelegate.color != color;
  }
}

class _SurfacePainter extends CustomPainter {
  _SurfacePainter({
    required this.path,
    required this.surface,
    required this.color,
    required this.gradient,
    required this.shadowColor,
    required this.elevation,
  });

  final Path path;
  final TabBarSurface surface;
  final Color color;
  final Gradient? gradient;
  final Color shadowColor;
  final double elevation;

  @override
  void paint(Canvas canvas, Size size) {
    if (elevation > 0) {
      canvas.drawShadow(path, shadowColor, elevation, true);
    }

    final paint = Paint()..style = PaintingStyle.fill;
    switch (surface) {
      case TabBarSurface.solid:
        paint.color = color;
        canvas.drawPath(path, paint);
      case TabBarSurface.gradient:
        paint.shader = (gradient ??
                LinearGradient(
                  colors: [color, color.withValues(alpha: 0.85)],
                ))
            .createShader(Offset.zero & size);
        canvas.drawPath(path, paint);
      case TabBarSurface.glass:
        break;
      case TabBarSurface.neumorphic:
        paint.color = color;
        canvas.drawPath(path, paint);
        final light = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = Colors.white.withValues(alpha: 0.9);
        final dark = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = Colors.black.withValues(alpha: 0.22);
        canvas.save();
        canvas.translate(-1, -1);
        canvas.drawPath(path, light);
        canvas.restore();
        canvas.save();
        canvas.translate(1, 1);
        canvas.drawPath(path, dark);
        canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _SurfacePainter oldDelegate) {
    return oldDelegate.path != path ||
        oldDelegate.surface != surface ||
        oldDelegate.color != color ||
        oldDelegate.gradient != gradient ||
        oldDelegate.shadowColor != shadowColor ||
        oldDelegate.elevation != elevation;
  }
}
