import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'profile_header.dart';

// =====================================================
// BASE PROFILE LAYOUT
// =====================================================
class BaseProfileLayout extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBack;

  const BaseProfileLayout({
    super.key,
    required this.child,
    this.header,
    this.title,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // =====================================================
        // HEADER (maroon gradient + wave)
        // =====================================================
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: header ?? const ProfileHeader(),
        ),

        // =====================================================
        // CREAM CONTENT AREA (curved top)
        // =====================================================
        Positioned(
          top: 115,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),

        // =====================================================
        // TOP APP BAR (on maroon header)
        // =====================================================
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // back button
                  showBackButton
                      ? _NavIcon(
                          icon: Icons.arrow_back,
                          onPressed: onBack ?? () => Navigator.pop(context),
                        )
                      : const SizedBox(width: 44),

                  // title
                  if (title != null && title!.isNotEmpty)
                    Text(
                      title!,
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    )
                  else
                    const SizedBox(),

                  const SizedBox(width: 44),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================
// NAV ICON (glass circle button)
// =====================================================
class _NavIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _NavIcon({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // fix: withOpacity → withValues
          color: Colors.white.withValues(alpha: 0.18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.28),
            width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}