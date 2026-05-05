import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/tags_provider.dart';
import 'tags_toggle.dart';
import 'tags_wrap.dart';

class TagsSection extends StatefulWidget {
  final List<String> dietaryTags;
  final List<String> interestTags;

  final ValueChanged<List<String>> onDietaryChanged;
  final ValueChanged<List<String>> onInterestChanged;

  const TagsSection({
    super.key,
    required this.dietaryTags,
    required this.interestTags,
    required this.onDietaryChanged,
    required this.onInterestChanged,
  });

  @override
  State<TagsSection> createState() => _TagsSectionState();
}

class _TagsSectionState extends State<TagsSection> {
  // =====================================================
  // LOCAL UI STATE
  // =====================================================
  bool isExpanded = true;
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TagsProvider>();

    // =====================================================
    // CURRENT TAG DATA (BASED ON SELECTED TAB)
    // =====================================================
    final currentTags = selectedTab == 0
        ? widget.dietaryTags
        : widget.interestTags;

    final currentOptions = selectedTab == 0
        ? [...provider.dietaryOptions, ...provider.customDietaryTags]
        : [...provider.interestOptions, ...provider.customInterestTags];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        children: [
          // =====================================================
          // HEADER (TAB TOGGLE + EXPAND BUTTON)
          // =====================================================
          Row(
            children: [
              // --- TAG TYPE TOGGLE (DIETARY / INTEREST) ---
              Expanded(
                child: TagsToggle(
                  selectedIndex: selectedTab,
                  onChanged: (i) {
                    setState(() {
                      selectedTab = i;
                      isExpanded = true;
                    });
                  },
                ),
              ),

              // --- EXPAND / COLLAPSE BUTTON ---
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 250),
                  turns: isExpanded ? 0 : 0.5,
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
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),

                    // --- TAG LIST (SELECTABLE + ADDABLE TAGS) ---
                    child: TagsWrap(
                      selectedTags: currentTags,
                      options: currentOptions,
                      tab: selectedTab,

                      onChanged: (updated) {
                        if (selectedTab == 0) {
                          widget.onDietaryChanged(updated);
                        } else {
                          widget.onInterestChanged(updated);
                        }
                      },
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
