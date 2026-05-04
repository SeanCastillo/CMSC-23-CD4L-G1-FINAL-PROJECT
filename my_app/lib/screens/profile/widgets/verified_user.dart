import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../providers/profile_provider.dart';

// =====================================================
// VERIFIED USER — display name + verified badge
// =====================================================
class VerifiedUser extends StatelessWidget {
  final double fontSize;
  final FontWeight fontWeight;
  final Color? nameColor;

  const VerifiedUser({
    super.key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.nameColor,
  });

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          profile.name.isNotEmpty ? profile.name : 'No Name',
          style: GoogleFonts.playfairDisplay(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: nameColor ?? AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),

        if (profile.isVerified) ...[
          const SizedBox(width: 6),
          Container(
            width: fontSize * 0.85,
            height: fontSize * 0.85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.verified,
              boxShadow: [
                BoxShadow(
                  // fix: withOpacity → withValues
                  color: AppColors.verified.withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: fontSize * 0.5,
            ),
          ),
        ],
      ],
    );
  }
}