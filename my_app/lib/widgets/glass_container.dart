import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// =====================================================
// GLASS CONTAINER
// light-mode glassmorphism using dart:ui only
// no external packages — BackdropFilter + ImageFilter.blur
// https://api.flutter.dev/flutter/widgets/BackdropFilter-class.html
// =====================================================
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final Color? fillColor;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;
  final double? width;
  final double? height;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 24,
    this.blur = 14,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.shadows,
    this.width,
    this.height,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows ??
            [
              // depth shadow — subtle maroon tint
              BoxShadow(
                color: AppColors.maroon.withValues(alpha: 0.07),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
              // top highlight — makes it feel lifted
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.90),
                blurRadius: 0,
                spreadRadius: 0,
                offset: const Offset(0, -1),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (fillColor ?? Colors.white).withValues(alpha: 0.72),
                      (fillColor ?? Colors.white).withValues(alpha: 0.55),
                    ],
                  ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? Colors.white.withValues(alpha: 0.85),
                width: borderWidth,
              ),
            ),
            child: Stack(
              children: [
                // ============================================
                // TOP EDGE HIGHLIGHT
                // white gradient line simulates light on glass edge
                // ============================================
                Positioned(
                  top: 0,
                  left: borderRadius,
                  right: borderRadius,
                  height: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.65),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// GLASS PILL — smaller variant for chips/buttons/badges
// =====================================================
class GlassPill extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  const GlassPill({
    super.key,
    required this.child,
    this.padding,
    this.fillColor,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: 50,
        blur: 10,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        fillColor: fillColor,
        borderColor: borderColor,
        shadows: [
          BoxShadow(
            color: AppColors.maroon.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        child: child,
      ),
    );
  }
}