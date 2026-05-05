import 'package:flutter/material.dart';
import '../models/post_model.dart';

class PantryProvider extends ChangeNotifier {
  // =====================================================
  // STATE
  // =====================================================
  final List<PantryPost> _posts = [];

  List<PantryPost> get posts => _posts;

  // =====================================================
  // CREATE
  // =====================================================
  void addPost(PantryPost post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  // =====================================================
  // UPDATE
  // =====================================================
  void updatePost(PantryPost updated) {
    final index = _posts.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _posts[index] = updated;
      notifyListeners();
    }
  }

  // =====================================================
  // DELETE
  // =====================================================
  void deletePost(String id) {
    _posts.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
