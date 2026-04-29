import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import 'profile_settings/profile_settings_screen.dart';

// widgets
import '../widgets/base_profile_layout.dart';
import '../widgets/profile_card.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_nav_buttons.dart';

// TODO:
// - user display name vs username (can't be changed!)
// - Dietary / Interest tags (actual filtering mechanics)
// - Pantry Tabs (Available / Looking for) (+ CRUD)
// - Firebase integration


// =====================================================
// PROFILE SCREEN
// =====================================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});


  // =====================================================
  // NAVIGATION: OPEN SETTINGS SCREEN
  // =====================================================
  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileSettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {

    // access profile data from provider
    final profile = context.watch<ProfileProvider>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // =====================================================
            // BASE LAYOUT
            // =====================================================
            BaseProfileLayout(
              child: ProfileCard(profile: profile),
            ),

            // =====================================================
            // FLOATING ELEMENTS (stacked above base btww)
            // =====================================================
            ProfileAvatar(profile: profile),
            ProfileNavButtons(onEdit: () => _openSettings(context)),
          ],
        ),
      ),
    );
  }
}