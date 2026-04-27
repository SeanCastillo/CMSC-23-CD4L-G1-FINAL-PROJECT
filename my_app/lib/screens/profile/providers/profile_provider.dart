import 'package:flutter/material.dart';


// =====================================================
// PROFILE PROVIDER
// =====================================================
class ProfileProvider extends ChangeNotifier {

  // --- USER DATA ---
  String userName = "username"; // NOTE: treated as uid for now
  String name = "Jane Doe";
  String email = "jane@email.com";
  String role = "community_member";

  bool isVerified = false; // 👈 NEW

  List<String> tags = [];

  String? imagePath;

  // =====================================================
  // UPDATE PROFILE
  // =====================================================
  void updateProfile({
    required String name,
    required String userName,
    String? email,
    String? imagePath,
  }) {
    this.name = name;
    this.userName = userName;

    if (email != null) this.email = email;
    this.imagePath = imagePath;

    notifyListeners();
  }

  // =====================================================
  // VERIFY USER
  // =====================================================
  void verifyUser() {
    isVerified = true;
    notifyListeners();
  }

  // =====================================================
  // OPTIONAL: UNVERIFY (for testing/debug hehueh)
  // =====================================================
  void unverifyUser() {
    isVerified = false;
    notifyListeners();
  }

  // =====================================================
  // UPDATE TAGS 
  // =====================================================
  void updateTags(List<String> newTags) {
    tags = newTags;
    notifyListeners();
  }
}