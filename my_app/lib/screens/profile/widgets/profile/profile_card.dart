import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/profile_provider.dart';
import '../profile_tags/tags_section.dart';
import 'verified_user.dart';

// =====================================================
// PROFILE CARD
// =====================================================
class ProfileCard extends StatefulWidget {

  const ProfileCard({super.key,});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    return Column(
      children: [
        const SizedBox(height: 10),

        // =====================================================
        // USER STATS (ITEMS / GIVES)
        // =====================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // --- ITEMS COUNT ---
            Column(
              children: [
                Text(
                  "123",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("Items"),
              ],
            ),
            SizedBox(width: 200),

            // -- GIVES COUNT ---
            Column(
              children: [
                Text(
                  "123",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("Gives"),
              ],
            ),
          ],
        ),

        // =====================================================
        // NAME + VERIFIED BADGE
        // =====================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const VerifiedUser(fontSize: 18)],
        ),

        // =====================================================
        // USERNAME DISPLAY
        // =====================================================
        Text(
          profile.userName.isNotEmpty ? "@${profile.userName}" : "@no_username",
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),

        const SizedBox(height: 6),

        // =====================================================
        // LOCATION (PLACEHOLDER)
        // =====================================================
        const Text("📍 City, Country"),

        const SizedBox(height: 10),

        // =====================================================
        // TAGS SECTION (DIETARY / INTERESTS)
        // =====================================================
        TagsSection(
          dietaryTags: profile.dietaryTags,
          interestTags: profile.interestTags,

          onDietaryChanged: (tags) {
            profile.setDietaryTags(tags);
          },

          onInterestChanged: (tags) {
            profile.setInterestTags(tags);
          },
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}
