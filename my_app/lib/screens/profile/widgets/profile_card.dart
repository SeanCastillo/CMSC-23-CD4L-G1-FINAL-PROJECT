import 'package:flutter/material.dart';
import '../providers/profile_provider.dart';
import 'tags/tags_section.dart';
import 'verified_user.dart';

// =====================================================
// PROFILE CARD
// =====================================================
class ProfileCard extends StatelessWidget {
  final ProfileProvider profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
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
        const TagsSection(),

        const SizedBox(height: 10),

        // =====================================================
        // PANTRY SECTION
        // =====================================================

        // --- PANTRY HEADER ---
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Pantry",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // --- PANTRY CONTENT (PLACEHOLDER) ---
        const SizedBox(
          height: 200,
          child: Center(
            child: Text(
              "Your posts / pantry items go here",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
