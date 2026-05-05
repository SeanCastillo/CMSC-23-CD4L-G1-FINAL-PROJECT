import 'package:flutter/material.dart';

// =====================================================
// TAGS TOGGLE TAB SWITCHING UI (DIETARY / INTERESTS)
// =====================================================
class TagsToggle extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const TagsToggle({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
          _button("Dietary", 0),
          // --- INTEREST TAB BUTTON ---
          _button("Interests", 1),
        ],
      ),
    );
  }

  // =====================================================
  // BUILD TOGGLE BUTTON
  // =====================================================
  Widget _button(String title, int index) {
    final selected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        // --- TAB SWITCH ACTION ---
        onTap: () => onChanged(index),
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
