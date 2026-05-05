import 'package:flutter/material.dart';

enum TagAction { create, manage }

class TagsBottomSheet {
  // =====================================================
  // OPEN BOTTOM SHEET (TAG ACTION SELECTOR)
  // =====================================================
  static Future<TagAction?> open(BuildContext context) {
    return showModalBottomSheet<TagAction>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- HEADER TITLE ---
          const Text(
            "Tag Options",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 12),
          // --- CREATE CUSTOM TAG OPTION ---
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Create Custom Tag"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () {
              Navigator.pop(context, TagAction.create);
            },
          ),

          const SizedBox(height: 4),

          // --- MANAGE TAGS OPTION ---
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Manage Tags"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () {
              Navigator.pop(context, TagAction.manage);
            },
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
