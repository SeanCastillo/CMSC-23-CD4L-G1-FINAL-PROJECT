import 'package:flutter/material.dart';

// =====================================================
// TAGS PROVIDER
// =====================================================
class TagsProvider extends ChangeNotifier {
  // --- TAB STATE (0 = Dietary, 1 = Interests) ---
  int selectedTab = 0;

  void setTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  // =====================================================
  // EXPAND / COLLAPSE
  // =====================================================
  bool isExpanded = true;

  void toggleExpanded() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

  // =====================================================
  // PRESET TAGS OPTIONS (for now...)
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
  // CUSTOM TAGS
  // =====================================================
  final List<String> _customDietaryTags = [];
  final List<String> _customInterestTags = [];

  List<String> get customDietaryTags => _customDietaryTags;
  List<String> get customInterestTags => _customInterestTags;

  // =====================================================
  // SELECTED TAGS
  // =====================================================
  List<String> _dietaryTags = [];
  List<String> _interestTags = [];

  List<String> get dietaryTags => _dietaryTags;
  List<String> get interestTags => _interestTags;

  // =====================================================
  // CURRENT VIEW HELPERS
  // =====================================================
  List<String> get currentSelected =>
      selectedTab == 0 ? _dietaryTags : _interestTags;

  List<String> get currentOptions => selectedTab == 0
      ? [...dietaryOptions, ..._customDietaryTags]
      : [...interestOptions, ..._customInterestTags];

  // =====================================================
  // ADD CUSTOM TAG
  // =====================================================
  void addTag(String tag) {
    if (tag.trim().isEmpty) return;

    if (selectedTab == 0) {
      if (!_customDietaryTags.contains(tag)) {
        _customDietaryTags.add(tag);
        _dietaryTags.add(tag);
      }
    } else {
      if (!_customInterestTags.contains(tag)) {
        _customInterestTags.add(tag);
        _interestTags.add(tag);
      }
    }

    notifyListeners();
  }

  // =====================================================
  // SET SELECTED TAGS (FROM MODAL)
  // =====================================================
  void setSelectedTags(List<String> tags) {
    if (selectedTab == 0) {
      _dietaryTags = tags;

      // remove unused custom tags
      _customDietaryTags.removeWhere((tag) => !_dietaryTags.contains(tag));
    } else {
      _interestTags = tags;

      _customInterestTags.removeWhere((tag) => !_interestTags.contains(tag));
    }

    notifyListeners();
  }

  // =====================================================
  // REMOVE TAG (not sure if I should do it here or in manage tags but imma keep for nows)
  // =====================================================
  void removeTag(String tag) {
    if (selectedTab == 0) {
      _dietaryTags.remove(tag);
      _customDietaryTags.remove(tag);
    } else {
      _interestTags.remove(tag);
      _customInterestTags.remove(tag);
    }

    notifyListeners();
  }

  // =====================================================
  // RESET (im gonna use this later trust twin)
  // =====================================================
  void reset() {
    _dietaryTags.clear();
    _interestTags.clear();
    _customDietaryTags.clear();
    _customInterestTags.clear();
    notifyListeners();
  }
}
