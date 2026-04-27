import 'dart:io';
import 'package:flutter/material.dart';
import '../providers/profile_provider.dart';

// =====================================================
// AVATAR
// =====================================================
class ProfileAvatar extends StatelessWidget {
  final ProfileProvider profile;

  const ProfileAvatar({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      // =====================================================
      // CENTER AVATAR ON SCREEN
      // =====================================================
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(3),
          // --- OUTER BORDER (WHITE RING) ---
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: CircleAvatar(
            radius: 65,
            // =====================================================
            // PROFILE IMAGE SOURCE (file img / fallback asset img)
            // =====================================================
            backgroundImage: profile.imagePath != null
                ? FileImage(File(profile.imagePath!))
                : const AssetImage("assets/profile.jpg") as ImageProvider,
          ),
        ),
      ),
    );
  }
}
