import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../providers/tags_provider.dart';

// =====================================================
// TAGS TOGGLE (Dietary / Interests tab switcher)
// =====================================================
class TagsToggle extends StatelessWidget {
  const TagsToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = context.watch<TagsProvider>();

    return Container(
      height: 34,
      decoration: BoxDecoration(
        // fix: withOpacity → withValues
        color: AppColors.blush.withValues(alpha: 0.50),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blush, width: 1),
      ),
      child: Row(
        children: [
          _TabPill(title: 'Dietary', index: 0, tags: tags),
          _TabPill(title: 'Interests', index: 1, tags: tags),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String title;
  final int index;
  final TagsProvider tags;

  const _TabPill({
    required this.title,
    required this.index,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = tags.selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => tags.setTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.maroon : Colors.transparent,
            borderRadius: BorderRadius.circular(17),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.maroon.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: isSelected ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}