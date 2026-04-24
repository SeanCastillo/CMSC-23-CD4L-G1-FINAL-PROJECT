import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_provider.dart';
import 'profile_settings_screen.dart';

// TODO: 
// - user display name vs username (can't be changed!)
// - Dietary Tags
// - Verification status
// - Pantry Tabs (Available / Looking for) (+ CRUD)
// - Firebase integration

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // --- FUNCTION: open profile settings ---
  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileSettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            // =====================================================
            // MAIN CONTENT
            // =====================================================
            Column(
              children: [

                // --- HEADER ---
                Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      profile.bio,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 60), 
                
                // user display name
                Text(
                  "${profile.firstName} ${profile.lastName}",
                  style: const TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 4),

                // user location
                const Text("location here"),

                const SizedBox(height: 20),

                // --- PANTRY SECTION ---
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "Pantry",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Your posts / pantry items go here",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // =====================================================
            // FLOATING AVATAR 
            // =====================================================
            Positioned(
              top: 130,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: ClipOval(
                    child: profile.imagePath != null
                        ? Image.file(
                            File(profile.imagePath!),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/profile.jpg",
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),

            // =====================================================
            // NAVIGATION BUTTONS
            // =====================================================

            // --- EDIT PROFILE ---
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => _openSettings(context),
              ),
            ),
            

            // --- BACK ---
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}