import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tags_provider.dart';
import 'tags_bottom_sheet.dart';

// =====================================================
// TAGS WRAP (CHIP LIST)
// =====================================================
class TagsWrap extends StatelessWidget {
  const TagsWrap({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = context.watch<TagsProvider>();

    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        // --- TAG ITEMS ---
        children: [
          ...tags.currentSelected.map(
            (tag) => Chip(
              label: Text(tag),
              // --- CHIP STYLING ---
              backgroundColor: Colors.grey[300],
              shape: const StadiumBorder(),
              side: BorderSide.none,
            ),
          ),
          // =====================================================
          // ADD TAG BUTTON (tag actions)
          // =====================================================
          GestureDetector(
            onTap: () => TagsBottomSheet.open(context),
            child: Chip(
              label: const Icon(Icons.add, color: Colors.green),
              backgroundColor: Colors.green.shade100,
              shape: const StadiumBorder(),
              side: BorderSide.none,
            ),
          ),
        ],
      ),
    );
  }
}
