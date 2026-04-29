import 'package:flutter/material.dart';

// =====================================================
// NAVIGATION BUTTONS
// =====================================================
class ProfileNavButtons extends StatelessWidget {
  final VoidCallback onEdit;

  const ProfileNavButtons({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        // --- EDIT PROFILE (SETTINGS) ---
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: onEdit,
          ),
        ),
        // --- RETURN TO LOGIN PAGE (FOR NOW) ---
        Positioned(
          top: 10,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ),
      ],
    );
  }
}