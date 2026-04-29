import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tags_provider.dart';
import '../../screens/profile_tag_page.dart';
import 'tags_manage_popup.dart';

// =====================================================
// TAGS BOTTOM SHEET
// =====================================================
class TagsBottomSheet {
  static void open(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // --- SHEET STYLING ---
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _Content(),
    );
  }
}

// =====================================================
// BOTTOM SHEET CONTENT (actions: create / manage tags)
// =====================================================
class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final tags = context.read<TagsProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- HEADER TITLE ---
          const Text(
            "Tag Options",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          // --- CREATE CUSTOM TAG OPTION ---
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Create Custom Tag"),
            onTap: () async {
              Navigator.pop(context);

              // nav to custom tag page
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CustomTagPage(existingTags: tags.currentOptions),
                ),
              );

              // add tag if result exists
              if (result != null) {
                tags.addTag(result);
              }
            },
          ),

          // --- MANAGE TAGS OPTION ---
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Manage Tags"),
            onTap: () async {
              Navigator.pop(context);

              // open manage tags popup
              final result = await showModalBottomSheet<List<String>>(
                context: context,
                isScrollControlled: true,
                builder: (_) => ManageTagsPopup(
                  options: tags.currentOptions,
                  selected: tags.currentSelected,
                ),
              );
              
              // update selected tags
              if (result != null) {
                tags.setSelectedTags(result);
              }
            },
          ),
        ],
      ),
    );
  }
}
