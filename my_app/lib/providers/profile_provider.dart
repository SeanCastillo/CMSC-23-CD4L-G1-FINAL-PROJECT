import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  // --- USER DATA ---
  String userName = "username";
  String name = "Jane Doe";
  String email = "jane@email.com";
  String role = "community_member";

  // --- TAGS ---
  List<String> dietaryTags = [];
  List<String> interestTags = [];

  bool isVerified = false; 

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
  void setDietaryTags(List<String> tags) {
    dietaryTags = List.from(tags);
    notifyListeners();
  }

  void setInterestTags(List<String> tags) {
    interestTags = List.from(tags);
    notifyListeners();
  }
}
