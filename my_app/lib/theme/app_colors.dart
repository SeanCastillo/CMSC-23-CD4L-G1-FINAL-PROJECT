import 'package:flutter/material.dart';

// =====================================================
// HATID — COLOR SYSTEM
// palette from moodboard: maroon / brown / blush
// =====================================================
class AppColors {
  AppColors._();

  // --- BRAND ---
  static const Color maroon     = Color(0xFF550C1B);
  static const Color brownDark  = Color(0xFF443730);
  static const Color brownMid   = Color(0xFF786452);
  static const Color tan        = Color(0xFFA5907E);
  static const Color blush      = Color(0xFFF7DAD9);
  static const Color blushLight = Color(0xFFFDF0EF);
  static const Color cream      = Color(0xFFFBF5F4);

  // --- TEXT ---
  static const Color textPrimary   = brownDark;
  static const Color textSecondary = brownMid;
  static const Color textMuted     = tan;

  // --- GLASS (light mode) ---
  // these are used by GlassContainer
  static const Color glassFill         = Color(0xB0FFFFFF); // ~69% white
  static const Color glassBorder       = Color(0xCCFFFFFF); // ~80% white
  static const Color glassBorderStrong = Color(0xF0FFFFFF); // ~94% white

  // --- VERIFIED BADGE ---
  static const Color verified = Color(0xFF2563EB);
}