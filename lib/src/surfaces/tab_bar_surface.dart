import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/enums.dart';

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

    if (surface == TabBarSurface.glass) {
      painted = Stack(
        fit: StackFit.expand,
        children: [
          ClipPath(
            clipper: _PathClipper(path),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
          painted,
        ],
      );
    } else if (clipChild) {
      painted = ClipPath(clipper: _PathClipper(path), child: painted);
    }
    return painted;
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
    if (elevation > 0 && surface != TabBarSurface.glass) {
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
        paint.color = color.a < 1 ? color : color.withValues(alpha: 0.72);
        canvas.drawPath(path, paint);
        final border = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = Colors.white.withValues(alpha: 0.55);
        canvas.drawPath(path, border);
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
