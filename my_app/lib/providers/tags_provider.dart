import 'package:flutter/material.dart';

class TagsProvider extends ChangeNotifier {
  // =====================================================
  // PRESET TAGS
  // =====================================================
  final List<String> dietaryOptions = [
    "Vegan",
    "Vegetarian",
    "Halal",
    "Kosher",
    "Gluten-Free",
    "Dairy-Free",
    "Keto",
    "Pescatarian",
  ];

  final List<String> interestOptions = [
    "Home-Cooked",
    "Baking",
    "Desserts",
    "Meal Prep",
    "Plant-Based",
  ];

  // =====================================================
  // CUSTOM TAGS (GLOBAL POOL)
  // =====================================================
  final List<String> _customDietaryTags = [];
  final List<String> _customInterestTags = [];

  List<String> get customDietaryTags => _customDietaryTags;
  List<String> get customInterestTags => _customInterestTags;

  // =====================================================
  // ALL OPTIONS
  // =====================================================
  List<String> getAllDietary() => [...dietaryOptions, ..._customDietaryTags];

  List<String> getAllInterest() => [...interestOptions, ..._customInterestTags];

  // =====================================================
  // ADD CUSTOM TAG (ONLY ADDS TO POOL)
  // =====================================================
  void addCustomTag(String tag, int tab) {
    final normalized = tag.toLowerCase().trim();
    if (normalized.isEmpty) return;

    if (tab == 0) {
      if (!_customDietaryTags.any(
        (e) => e.toLowerCase().trim() == normalized,
      )) {
        _customDietaryTags.add(tag);
      }
    } else {
      if (!_customInterestTags.any(
        (e) => e.toLowerCase().trim() == normalized,
      )) {
        _customInterestTags.add(tag);
      }
    }

    notifyListeners();
  }

  // =====================================================
  // REMOVE CUSTOM TAG
  // =====================================================
  void removeCustomTag(String tag, int tab) {
    if (tab == 0) {
      _customDietaryTags.remove(tag);
    } else {
      _customInterestTags.remove(tag);
    }

    notifyListeners();
  }
}
