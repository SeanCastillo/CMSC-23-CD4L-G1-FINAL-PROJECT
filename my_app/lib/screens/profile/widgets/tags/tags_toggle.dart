import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tags_provider.dart';

// =====================================================
// TAGS TOGGLE TAB SWITCHING UI (DIETARY / INTERESTS)
// =====================================================
class TagsToggle extends StatelessWidget {
  const TagsToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = context.watch<TagsProvider>();

    return Container(
      height: 36,

      // =====================================================
      // TOGGLE BACKGROUND STYLING
      // =====================================================
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // --- DIETARY TAB BUTTON ---
          _button(context, "Dietary", 0, tags),
          // --- INTEREST TAB BUTTON ---
          _button(context, "Interests", 1, tags),
        ],
      ),
    );
  }

  // =====================================================
  // BUILD TOGGLE BUTTON
  // =====================================================
  Widget _button(
    BuildContext context,
    String title,
    int index,
    TagsProvider tags,
  ) {
    final selected = tags.selectedTab == index;

    return Expanded(
      child: GestureDetector(

        // --- TAB SWITCH ACTION ---
        onTap: () => tags.setTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          // --- BUTTON STYLING (SELECTED / UNSELECTED)
          decoration: BoxDecoration(
            color: selected ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
