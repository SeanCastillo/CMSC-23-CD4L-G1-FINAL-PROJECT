import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/pantry_provider.dart';
import 'pantry_view_post.dart';

class PantryGrid extends StatelessWidget {
  const PantryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = context.watch<PantryProvider>().posts;

    return GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),

      // --- GRID ITEM COUNT ---
      itemCount: posts.length,

      // =====================================================
      // GRID LAYOUT CONFIGURATION
      // =====================================================
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (_, i) {
        // --- DATE SOURCE (PANTRY POSTS) ---
        final post = posts[i];

        return GestureDetector(
          // open post detail sheet here
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              barrierColor: Colors.black.withValues(alpha: 0.4),
              builder: (_) => PantryPostDetailSheet(post: post),
            );
          },

          // =====================================================
          // GRID IMAGE PREVIEW
          // =====================================================
          child: Image.file(File(post.imagePath), fit: BoxFit.cover),
        );
      },
    );
  }
}
