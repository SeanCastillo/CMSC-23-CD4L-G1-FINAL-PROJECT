import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

// =====================================================
// PROFILE HEADER — maroon radial gradient + organic wave
// =====================================================
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          // base gradient
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.6, -0.9),
                radius: 2.0,
                colors: [
                  Color(0xFF7D1B2B),
                  AppColors.maroon,
                  AppColors.brownDark,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // shimmer overlay (depth)
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-1.0, -1.0),
                end: const Alignment(1.0, 1.0),
                colors: [
                  // fix: withOpacity → withValues
                  Colors.white.withValues(alpha: 0.07),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.12),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // organic wave edge
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: _HeaderWavePainter(),
              size: const Size(double.infinity, 72),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// WAVE PAINTER (bezier curves into cream)
// =====================================================
class _HeaderWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.cream
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.58);
    path.cubicTo(
      size.width * 0.18, size.height * 0.0,
      size.width * 0.38, size.height * 0.95,
      size.width * 0.60, size.height * 0.42,
    );
    path.cubicTo(
      size.width * 0.76, size.height * 0.05,
      size.width * 0.88, size.height * 0.60,
      size.width, size.height * 0.32,
    );
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}