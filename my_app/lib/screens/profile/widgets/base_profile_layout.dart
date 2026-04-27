import 'package:flutter/material.dart';
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
        // HEADER
        // =====================================================
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: header ?? const ProfileHeader(),
        ),

        // =====================================================
        // CURVED CONTENT
        // =====================================================
        Positioned(
          top: 115,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: child,
                ),
              ),
            ),
          ),
        ),

        // =====================================================
        // TOP BAR
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
                  // --- BACK BUTTON ---
                  showBackButton
                      ? IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: onBack ?? () => Navigator.pop(context),
                        )
                      : const SizedBox(width: 48),

                  // --- TITLE ---
                  Text(
                    title ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // to balance ts
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
