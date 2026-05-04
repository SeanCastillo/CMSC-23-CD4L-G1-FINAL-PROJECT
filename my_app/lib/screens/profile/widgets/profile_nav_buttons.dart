import 'package:flutter/material.dart';

// =====================================================
// PROFILE NAV BUTTONS — glass circle buttons on header
// =====================================================
class ProfileNavButtons extends StatelessWidget {
  final VoidCallback onEdit;

  const ProfileNavButtons({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 10,
          right: 10,
          child: SafeArea(
            child: _GlassNavBtn(icon: Icons.edit_outlined, onPressed: onEdit),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: SafeArea(
            child: _GlassNavBtn(
              icon: Icons.arrow_back,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassNavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _GlassNavBtn({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // fix: withOpacity → withValues
          color: Colors.white.withValues(alpha: 0.18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.30),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}