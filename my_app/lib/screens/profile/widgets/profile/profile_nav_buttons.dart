import 'package:flutter/material.dart';

// =====================================================
// NAVIGATION BUTTONS
// =====================================================
class ProfileNavButtons extends StatelessWidget {
  const ProfileNavButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // --- BACK BUTTON ---
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}