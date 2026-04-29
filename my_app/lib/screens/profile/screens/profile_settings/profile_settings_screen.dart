import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/profile_provider.dart';
import '../../widgets/base_profile_layout.dart';
import '../../widgets/verified_user.dart';
import 'profile_settings_user_page.dart';
import '../../widgets/profile_settings_about.dart';
import 'profile_settings_security_page.dart';

// =====================================================
// PROFILE SETTINGS SCREEN
// =====================================================
class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // access profile data from provider
    final profile = context.watch<ProfileProvider>();

    return Scaffold(
      body: SafeArea(
        child: BaseProfileLayout(
          // --- HEADER ---
          title: "Settings",
          showBackButton: true,

          // =====================================================
          // MAIN CONTENT
          // =====================================================
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- PROFILE ROW ---
              Row(
                children: [
                  // --- PROFILE IMAGE ---
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profile.imagePath != null
                            ? FileImage(File(profile.imagePath!))
                            : const AssetImage("assets/profile.jpg")
                                  as ImageProvider,
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // --- NAME + USERNAME ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerifiedUser(fontSize: 18),

                      Text(
                        profile.userName.isNotEmpty
                            ? "@${profile.userName}"
                            : "@no_username",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // =====================================================
              // USER PROFILE SECTION
              // =====================================================
              _tile("User Profile", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserSettingsPage()),
                );
              }),
              _tile("Preferences"),
              _tile("Location"),

              const SizedBox(height: 25),

              // =====================================================
              // SYSTEM SECTION
              // =====================================================
              _tile("Notifications"),
              _tile("Security", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SecurityPage()),
                );
              }),
              _tile("Permissions"),

              const SizedBox(height: 25),

              // =====================================================
              // INFO SECTION
              // =====================================================
              _tile("About", () => showAppAboutDialog(context)),
              _tile("Help / Support", _openHelpLink),

              const SizedBox(height: 25),

              // =====================================================
              // LOGOUT
              // =====================================================
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: logout logic hereeee
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // TILE HELPER
  // =====================================================
  Widget _tile(String title, [VoidCallback? onTap]) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }

  // =====================================================
  // OPEN HELP LINK
  // =====================================================
  Future<void> _openHelpLink() async {
    final Uri url = Uri.parse(
      "https://github.com/SeanCastillo/CMSC-23-CD4L-G1-FINAL-PROJECT",
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
