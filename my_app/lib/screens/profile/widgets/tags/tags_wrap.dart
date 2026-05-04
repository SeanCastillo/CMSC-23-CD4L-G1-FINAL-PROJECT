import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../providers/tags_provider.dart';
import 'tags_bottom_sheet.dart';

// =====================================================
// TAGS WRAP — blush chips with maroon text + add button
// =====================================================
class TagsWrap extends StatelessWidget {
  const TagsWrap({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = context.watch<TagsProvider>();

    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 7,
        runSpacing: 7,
        children: [
          ...tags.currentSelected.map((tag) => _TagChip(label: tag)),

          // add button
          GestureDetector(
            onTap: () => TagsBottomSheet.open(context),
            child: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // fix: withOpacity → withValues
                color: AppColors.maroon.withValues(alpha: 0.10),
                border: Border.all(
                  color: AppColors.maroon.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: const Icon(Icons.add, color: AppColors.maroon, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.blush,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.maroon.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.maroon,
          height: 1,
        ),
      ),
    );
  }
}