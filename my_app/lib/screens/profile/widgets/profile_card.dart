import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/glass_container.dart';
import '../providers/profile_provider.dart';
import 'tags/tags_section.dart';
import 'verified_user.dart';

// =====================================================
// PROFILE CARD
// main content body of the profile screen
// =====================================================
class ProfileCard extends StatelessWidget {
  final ProfileProvider profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // space for the floating avatar
        const SizedBox(height: 74),

        // =====================================================
        // NAME + VERIFIED BADGE
        // =====================================================
        const VerifiedUser(fontSize: 22),

        const SizedBox(height: 4),

        // =====================================================
        // USERNAME
        // =====================================================
        Text(
          profile.userName.isNotEmpty
              ? '@${profile.userName}'
              : '@no_username',
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
            letterSpacing: 0.2,
          ),
        ),

        const SizedBox(height: 6),

        // =====================================================
        // LOCATION
        // =====================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 13,
              color: AppColors.tan,
            ),
            const SizedBox(width: 3),
            Text(
              'City, Country',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.tan,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // =====================================================
        // STATS ROW (glass pills)
        // =====================================================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              // items
              Expanded(
                child: _StatPill(label: 'Items', value: '123'),
              ),
              const SizedBox(width: 10),
              // rating (placeholder)
              Expanded(
                child: _StatPill(label: 'Rating', value: '4.9'),
              ),
              const SizedBox(width: 10),
              // gives
              Expanded(
                child: _StatPill(label: 'Gives', value: '45'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // =====================================================
        // TAGS SECTION (dietary / interests)
        // =====================================================
        const TagsSection(),

        const SizedBox(height: 16),

        // =====================================================
        // PANTRY SECTION
        // =====================================================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 10),
                child: Text('Pantry', style: AppTextStyles.displaySmall),
              ),

              // --- PLACEHOLDER (will be replaced with grid) ---
              GlassContainer(
                width: double.infinity,
                height: 180,
                borderRadius: 20,
                blur: 10,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.tan,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your pantry items will appear here',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),
      ],
    );
  }
}

// =====================================================
// STAT PILL (glass card for each stat)
// =====================================================
class _StatPill extends StatelessWidget {
  final String label;
  final String value;

  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 18,
      blur: 12,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: AppTextStyles.statNumber),
          const SizedBox(height: 3),
          Text(label, style: AppTextStyles.statLabel),
        ],
      ),
    );
  }
}