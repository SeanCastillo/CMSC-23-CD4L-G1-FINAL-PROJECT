import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {

  // === DEFAULT VALUES ===
  String firstName = "Jane";
  String lastName = "Doe";
  String bio = "Insert a creative bio here";
  String? imagePath;

  void updateProfile({
    required String firstName,
    required String lastName,
    required String bio,
    String? imagePath,
  }) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.bio = bio;
    this.imagePath = imagePath;

    notifyListeners();
  }
}