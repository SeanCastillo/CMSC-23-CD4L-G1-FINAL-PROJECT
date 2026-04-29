import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../services/camera_service.dart';

import '../../providers/profile_provider.dart';
import '../../widgets/base_profile_layout.dart';
import 'verification_cam_page.dart';

// =====================================================
// SECURITY PAGE
// =====================================================
class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  // local state: store captured verification img
  File? _verificationImage;

  // =====================================================
  // OPEN CAMERA
  // =====================================================
  Future<void> _openCamera() async {
    final image = await Navigator.push<File>(
      context,
      MaterialPageRoute(
        builder: (_) => CameraCapturePage(cameras: CameraService.cameras),
      ),
    );

    // --- HANDLE CAM RESULT ---
    if (image != null) {
      setState(() {
        _verificationImage = image;
      });

      Provider.of<ProfileProvider>(context, listen: false).verifyUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    // access profile state
    final profile = context.watch<ProfileProvider>();

    return Scaffold(
      body: SafeArea(
        child: BaseProfileLayout(
          // =====================================================
          // HEADER CONFIG
          // =====================================================
          title: "Security",
          showBackButton: true,
          // =====================================================
          // MAIN CONTENT
          // =====================================================
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // --- TITLE ---
              const Text(
                "User Verification",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // --- DESCRIPTION ---
              const Text(
                "Take a selfie to verify your account.",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // =====================================================
              // CAMERA BUTTON
              // =====================================================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _openCamera,
                  child: const Text("Open Camera"),
                ),
              ),

              const SizedBox(height: 20),

              // =====================================================
              // VERIFICATION STATUS
              // =====================================================
              if (_verificationImage != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Captured Image:"),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _verificationImage!,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              // =====================================================
              // STATUS
              // =====================================================
              Row(
                children: [
                  const Text("Status: "),
                  Icon(
                    profile.isVerified ? Icons.verified : Icons.error_outline,
                    color: profile.isVerified ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(profile.isVerified ? "Verified" : "Not Verified"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
