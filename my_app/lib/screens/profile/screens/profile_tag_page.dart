import 'package:flutter/material.dart';
import '../widgets/base_profile_layout.dart';
import '../../../utils/dupli_validator.dart';

// =====================================================
// CUSTOM TAG CREATION PAGE
// =====================================================
class CustomTagPage extends StatefulWidget {
  final List<String> existingTags;

  const CustomTagPage({super.key, required this.existingTags});

  @override
  State<CustomTagPage> createState() => _CustomTagPageState();
}

class _CustomTagPageState extends State<CustomTagPage> {
  // store current tag input
  String tagName = "";

  // =====================================================
  // DUPLICATE CHECK (CASE-INSENSITIVE)
  // =====================================================
  bool isDuplicate(String value) {
    return !hasNoDuplicatesBy([
      ...widget.existingTags,
      value,
    ], (e) => e.toLowerCase().trim());
  }

  @override
  Widget build(BuildContext context) {
    // --- INPUT VALIDATION STATES ---
    final trimmed = tagName.trim();
    final duplicate = isDuplicate(trimmed);

    return Scaffold(
      body: SafeArea(
        child: BaseProfileLayout(
          // --- TOP BAR CONFIG ---
          title: "Create Tag",
          showBackButton: true,

          // =====================================================
          // MAIN CONTENT
          // =====================================================
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TITLE ---
              const Text(
                "Custom Tag Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              // --- INPUT FIELD ---
              TextField(
                onChanged: (value) {
                  setState(() {
                    tagName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Tag name",
                  hintText: "e.g. Low Sodium, Keto Friendly",
                  border: const OutlineInputBorder(),

                  // ---- LIVE VALIDATION FEEDBACK ---
                  errorText: trimmed.isEmpty
                      ? null
                      : (duplicate ? "Tag already exists" : null),
                ),
              ),

              const SizedBox(height: 20),

              // =====================================================
              // CREATE BUTTON
              // =====================================================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),

                  // disable input if invalid
                  onPressed: trimmed.isEmpty || duplicate
                      ? null
                      : () {
                          // return new tag to previous screen
                          Navigator.pop(context, trimmed);
                        },

                  child: const Text("Create Tag"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
