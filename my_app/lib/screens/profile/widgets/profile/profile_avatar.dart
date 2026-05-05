import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/profile_provider.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    // safe area offset
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 50,
      left: 0,
      right: 0,

      // --- CENTER AVATAR ON SCREEN ---
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(3),

          // --- OUTER BORDER (WHITE RING) ---
          decoration: const BoxDecoration(
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
                : const AssetImage("assets/profile.jpg"),
          ),
        ),
      ),
    );
  }
}
