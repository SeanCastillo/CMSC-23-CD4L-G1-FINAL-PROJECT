import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/tags_provider.dart';
import '../../profile_tag_page.dart';
import 'tags_bottom_sheet.dart';
import 'tags_manage_popup.dart';

class TagsWrap extends StatelessWidget {
  final List<String> selectedTags;
  final List<String> options;
  final ValueChanged<List<String>> onChanged;
  final int tab;

  const TagsWrap({
    super.key,
    required this.selectedTags,
    required this.options,
    required this.onChanged,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          // =====================================================
          // SELECTED TAG CHIPS
          // =====================================================
          ...selectedTags.map(
            (tag) => Chip(
              label: Text(tag),
              backgroundColor: Colors.grey[300],
              shape: const StadiumBorder(),
              side: BorderSide.none,
            ),
          ),

          // =====================================================
          // ADD TAG BUTTON
          // =====================================================
          GestureDetector(
            onTap: () async {
              final action = await TagsBottomSheet.open(context);

              if (action == null) return;

              // --- CREATE NEW CUSTOM TAG ---
              if (action == TagAction.create) {
                final newTag = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CustomTagPage(existingTags: options),
                  ),
                );

                if (newTag != null) {
                  // save to provider state 
                  context.read<TagsProvider>().addCustomTag(newTag, tab);

                  // update local state
                  onChanged([...selectedTags, newTag]);
                }
              }

              // --- MANAGE EXISTING TAGS ---
              if (action == TagAction.manage) {
                final result = await showModalBottomSheet<List<String>>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) =>
                      ManageTagsPopup(options: options, selected: selectedTags),
                );

                if (result != null) {
                  onChanged(result);
                }
              }
            },
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
