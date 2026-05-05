import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/tags_provider.dart';

// =====================================================
// MANAGE TAGS POPUP (select / deselect tags)
// =====================================================
class ManageTagsPopup extends StatefulWidget {
  final List<String> options;
  final List<String> selected;

  const ManageTagsPopup({
    super.key,
    required this.options,
    required this.selected,
  });

  @override
  State<ManageTagsPopup> createState() => _ManageTagsPopupState();
}

class _ManageTagsPopupState extends State<ManageTagsPopup> {
  // --- TEMPORARY SELECTED STATE (user selection before saving) ---
  late List<String> tempSelected;

  @override
  // initialize temp state from provided selected tags
  void initState() {
    super.initState();
    tempSelected = List<String>.from(widget.selected);
  }

  // =====================================================
  // TOGGLE TAG SELECTION (add/ remove tag)
  // =====================================================
  void toggleTag(String tag) {
    setState(() {
      if (tempSelected.contains(tag)) {
        tempSelected.remove(tag);
      } else {
        tempSelected = [...tempSelected, tag];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        // fix for keyboard overflows... dawg...
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // =====================================================
          // HEADER
          // =====================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- TITLE ---
              const Text(
                "Manage Tags",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // --- SAVE BUTTON ---
              TextButton(
                onPressed: () {
                  final provider = context.read<TagsProvider>();

                  // find removed tags
                  final removedTags = widget.selected
                      .where((tag) => !tempSelected.contains(tag))
                      .toList();

                  for (final tag in removedTags) {
                    // Only remove if it's a CUSTOM tag
                    if (widget.options.contains(tag)) {
                      // detect tab automatically
                      final isDietary = provider.getAllDietary().contains(tag);

                      provider.removeCustomTag(tag, isDietary ? 0 : 1);
                    }
                  }

                  Navigator.pop(context, tempSelected);
                },
                child: const Text("Save"),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // =====================================================
          // TAG SELECTION GRID
          // =====================================================
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.options.map((tag) {
              final isSelected = tempSelected.contains(tag);

              return GestureDetector(
                // --- TOGGLE TAG ON TAP ---
                onTap: () => toggleTag(tag),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  // =====================================================
                  // TAG CHIP STYLING (SELECTED / UNSELECTED)
                  // =====================================================
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
