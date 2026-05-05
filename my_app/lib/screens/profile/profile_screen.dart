import 'package:flutter/material.dart';
import 'profile_settings/profile_settings_screen.dart';

// widgets
import 'widgets/profile/base_profile_layout.dart';
import 'widgets/profile/profile_card.dart';
import 'widgets/profile/profile_avatar.dart';
import 'widgets/profile/profile_nav_buttons.dart';
import 'widgets/profile/profile_floating_menu.dart';
import 'profile_pantry/profile_pantry_post_screen.dart';
import 'profile_settings/profile_settings_user_screen.dart';
import 'widgets/profile_pantry/pantry_section.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // =====================================================
            // BASE CONTENT (Profile + Pantry area)
            // =====================================================
            BaseProfileLayout(
              enableScroll: false,
              child: Column(
                children: const [
                  ProfileCard(),
                  Expanded(child: PantrySection()),
                ],
              ),
            ),

            // =====================================================
            // HEADER OVERLAYS
            // =====================================================
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: ProfileNavButtons(),
              ),
            ),

            ProfileAvatar(),

            // =====================================================
            // FLOATING MENU
            // =====================================================
            Align(
              alignment: Alignment.bottomRight,
              child: ProfileFloatingMenu(
                onCreatePost: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfilePantryPost(),
                    ),
                  );
                },
                onEditProfile: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserSettingsPage()),
                  );
                },
                onSettings: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileSettingsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
