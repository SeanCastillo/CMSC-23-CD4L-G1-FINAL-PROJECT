import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// fix: 4 levels up to reach lib/ from lib/screens/profile/screens/profile_settings/
import '../../../../theme/app_colors.dart';
import '../../../../widgets/glass_container.dart';

// fix: 2 levels up to reach lib/screens/profile/ 
import '../../providers/profile_provider.dart';
import '../../widgets/base_profile_layout.dart';
import '../../widgets/verified_user.dart';
import '../../widgets/profile_settings_about.dart';

// same folder
import 'profile_settings_user_page.dart';
import 'profile_settings_security_page.dart';

// =====================================================
// PROFILE SETTINGS SCREEN
// light glass tiles grouped by section
// =====================================================
class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    return Scaffold(
      body: SafeArea(
        child: BaseProfileLayout(
          title: 'Settings',
          showBackButton: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =====================================================
              // PROFILE SUMMARY ROW
              // =====================================================
              GlassContainer(
                width: double.infinity,
                borderRadius: 22,
                blur: 12,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.blush,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.blush,
                        backgroundImage: profile.imagePath != null
                            ? FileImage(File(profile.imagePath!))
                            : const AssetImage('assets/profile.jpg')
                                as ImageProvider,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // name + username
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VerifiedUser(fontSize: 16),
                          const SizedBox(height: 2),
                          Text(
                            profile.userName.isNotEmpty
                                ? '@${profile.userName}'
                                : '@no_username',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =====================================================
              // ACCOUNT SECTION
              // =====================================================
              const _SectionLabel(label: 'Account'),
              const SizedBox(height: 8),
              GlassContainer(
                width: double.infinity,
                borderRadius: 18,
                blur: 12,
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.person_outline_rounded,
                      title: 'User Profile',
                      isFirst: true,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UserSettingsPage(),
                        ),
                      ),
                    ),
                    _TileDivider(),
                    const _SettingsTile(
                      icon: Icons.tune_rounded,
                      title: 'Preferences',
                    ),
                    _TileDivider(),
                    const _SettingsTile(
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =====================================================
              // SYSTEM SECTION
              // =====================================================
              const _SectionLabel(label: 'System'),
              const SizedBox(height: 8),
              GlassContainer(
                width: double.infinity,
                borderRadius: 18,
                blur: 12,
                child: Column(
                  children: [
                    const _SettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      isFirst: true,
                    ),
                    _TileDivider(),
                    _SettingsTile(
                      icon: Icons.shield_outlined,
                      title: 'Security',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SecurityPage()),
                      ),
                    ),
                    _TileDivider(),
                    const _SettingsTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'Permissions',
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =====================================================
              // INFO SECTION
              // =====================================================
              const _SectionLabel(label: 'Info'),
              const SizedBox(height: 8),
              GlassContainer(
                width: double.infinity,
                borderRadius: 18,
                blur: 12,
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      title: 'About',
                      isFirst: true,
                      onTap: () => showAppAboutDialog(context),
                    ),
                    _TileDivider(),
                    _SettingsTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Help / Support',
                      isLast: true,
                      onTap: _openHelpLink,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =====================================================
              // LOGOUT BUTTON
              // =====================================================
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    // TODO: logout logic
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 16,
                    color: AppColors.maroon,
                  ),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.maroon,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.maroon,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openHelpLink() async {
    final Uri url = Uri.parse(
      'https://github.com/SeanCastillo/CMSC-23-CD4L-G1-FINAL-PROJECT',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}

// =====================================================
// SECTION LABEL
// =====================================================
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.nunito(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppColors.textMuted,
          letterSpacing: 0.12,
        ),
      ),
    );
  }
}

// =====================================================
// SETTINGS TILE
// =====================================================
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLast;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.blush,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.maroon, size: 18),
      ),
      title: Text(
        title,
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: AppColors.tan,
      ),
    );
  }
}

// =====================================================
// TILE DIVIDER
// =====================================================
class _TileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 64,
      endIndent: 0,
      color: AppColors.blush.withValues(alpha: 0.8),
    );
  }
}