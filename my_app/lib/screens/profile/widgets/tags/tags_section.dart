import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tags_provider.dart';
import 'tags_toggle.dart';
import 'tags_wrap.dart';

// =====================================================
// TAGS SECTION (MAIN CONTAINER)
// =====================================================
class TagsSection extends StatelessWidget {
  const TagsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = context.watch<TagsProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),

      // =====================================================
      // CONTAINER STYLING
      // =====================================================
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // =====================================================
          // HEADER ROW (TOGGLE + EXPAND BUTTON)
          // =====================================================
          Row(
            children: [
              // --- DIETARY / INTEREST BUTTON ---
              const Expanded(child: TagsToggle()),

              // --- EXPAND / COLLAPSE BUTTON ---
              GestureDetector(
                onTap: tags.toggleExpanded,
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 250),
                  turns: tags.isExpanded ? 0 : 0.5,
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              ),
            ],
          ),

          // =====================================================
          // EXPANDABLE TAG CONTENT
          // =====================================================
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: tags.isExpanded
                ? const Padding(
                    padding: EdgeInsets.only(top: 12),
                    // --- TAG LIST (tags + add button) ---
                    child: TagsWrap(),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
