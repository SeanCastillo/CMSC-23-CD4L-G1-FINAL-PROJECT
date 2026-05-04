import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/glass_container.dart';
import '../../providers/tags_provider.dart';
import 'tags_toggle.dart';
import 'tags_wrap.dart';

// =====================================================
// TAGS SECTION (glass card container)
// =====================================================
class TagsSection extends StatelessWidget {
  const TagsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = context.watch<TagsProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GlassContainer(
        borderRadius: 22,
        blur: 14,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // HEADER ROW
            // =====================================================
            Row(
              children: [
                // section label
                Text(
                  'My Tags',
                  style: GoogleFonts.nunito(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                    letterSpacing: 0.10,
                  ),
                ),
                const Spacer(),

                // toggle (dietary / interests)
                const Expanded(flex: 8, child: TagsToggle()),
                const SizedBox(width: 8),

                // expand / collapse
                GestureDetector(
                  onTap: tags.toggleExpanded,
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 250),
                    turns: tags.isExpanded ? 0 : 0.5,
                    child: Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: AppColors.tan,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            // =====================================================
            // EXPANDABLE TAG CHIPS
            // =====================================================
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              child: tags.isExpanded
                  ? const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: TagsWrap(),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}