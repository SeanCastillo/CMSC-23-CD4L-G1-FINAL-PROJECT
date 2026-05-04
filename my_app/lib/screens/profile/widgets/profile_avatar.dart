import 'dart:io';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../providers/profile_provider.dart';

// =====================================================
// PROFILE AVATAR
// =====================================================
class ProfileAvatar extends StatelessWidget {
  final ProfileProvider profile;

  const ProfileAvatar({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 46,
      left: 0,
      right: 0,
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // =====================================================
            // GRADIENT RING
            // =====================================================
            Container(
              width: 138,
              height: 138,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const SweepGradient(
                  startAngle: 0.0,
                  endAngle: 6.28,
                  colors: [
                    Color(0xFFFFFFFF),
                    AppColors.tan,
                    AppColors.maroon,
                    AppColors.brownMid,
                    Color(0xFFFFFFFF),
                  ],
                  stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    // fix: withOpacity → withValues
                    color: AppColors.maroon.withValues(alpha: 0.25),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.80),
                    blurRadius: 0,
                    spreadRadius: 2,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  radius: 64,
                  backgroundColor: AppColors.blush,
                  backgroundImage: profile.imagePath != null
                      ? FileImage(File(profile.imagePath!))
                      : const AssetImage('assets/profile.jpg') as ImageProvider,
                ),
              ),
            ),

            // =====================================================
            // VERIFIED BADGE
            // =====================================================
            if (profile.isVerified)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.verified,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.verified.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}