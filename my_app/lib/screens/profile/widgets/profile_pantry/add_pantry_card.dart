import 'package:flutter/material.dart';
import '../../profile_pantry/profile_pantry_post_screen.dart';

class AddPantryCard extends StatelessWidget {
  const AddPantryCard({super.key});

  // =====================================================
  // NAVIGATION (OPEN CREATE POST SCREEN)
  // =====================================================
  void _openCreatePost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePantryPost()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openCreatePost(context),

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

          // --- CARD BORDER STYLE ---
          border: Border.all(color: Colors.grey.shade400),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: const [
            // --- ADD ICON ---
            Icon(Icons.add, size: 36, color: Colors.grey),

            SizedBox(height: 6),

            // --- LABEL ---
            Text("Add Post", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
