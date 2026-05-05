import 'package:flutter/material.dart';

class ProfileFloatingMenu extends StatefulWidget {
  final VoidCallback onSettings;
  final VoidCallback onEditProfile;
  final VoidCallback onCreatePost;

  const ProfileFloatingMenu({
    super.key,
    required this.onSettings,
    required this.onEditProfile,
    required this.onCreatePost,
  });

  @override
  State<ProfileFloatingMenu> createState() => _ProfileFloatingMenuState();
}

class _ProfileFloatingMenuState extends State<ProfileFloatingMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool isOpen = false;

  // =====================================================
  // INIT ANIMATION CONTROLLER
  // =====================================================
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
  }

  // =====================================================
  // TOGGLE MENU OPEN / CLOSE STATE
  // =====================================================
  void toggleMenu() {
    setState(() {
      isOpen = !isOpen;
      isOpen ? _controller.forward() : _controller.reverse();
    });
  }

  // =====================================================
  // INDIVIDUAL MENU OPTION BUILDER
  // =====================================================
  Widget buildOption({
    required IconData icon,
    required int index,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final theme = Theme.of(context);

        // =====================================================
        // ANIMATION PROGRESS (EASE OUT)
        // =====================================================
        final progress = Curves.easeOutCubic
            .transform(_controller.value)
            .clamp(0.0, 1.0);

        // =====================================================
        // SPACING CONFIGURATION
        // =====================================================
        const double spacing = 70.0;
        const double baseDistanceFromMainButton = 100.0;

        final double offsetY = index * spacing * progress;

        return Positioned(
          bottom: baseDistanceFromMainButton + offsetY,
          right: 14,
          child: Transform.scale(
            scale: 0.7 + (0.25 * progress),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 60,
                      height: 60,

                      // --- BUTTON STYLE (PRIMARY / SECONDARY) ---
                      decoration: BoxDecoration(
                        color: isPrimary
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),

                      // --- ICON ---
                      child: Icon(
                        icon,
                        color: isPrimary
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
              ],
            ),
          ),
        );
      },
    );
  }

  // =====================================================
  // MAIN BUILD METHOD
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            // --- BACKDROP ---
            if (isOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: toggleMenu,
                  child: Container(color: Colors.transparent),
                ),
              ),

            // --- MENU OPTIONS ---
            if (_controller.value > 0) ...[
              buildOption(
                icon: Icons.settings,
                index: 0,
                isPrimary: false,
                onTap: widget.onSettings,
              ),
              buildOption(
                icon: Icons.edit,
                index: 1,
                isPrimary: false,
                onTap: widget.onEditProfile,
              ),
              buildOption(
                icon: Icons.add,
                index: 2,
                isPrimary: true,
                onTap: widget.onCreatePost,
              ),
            ],

            // --- MAIN FLOATING ACTION BUTTON ---
            Positioned(
              bottom: 16,
              right: 16,
              child: Transform.scale(
                scale: 1.0 + (_controller.value * 0.05),
                child: Material(
                  color: Theme.of(context).colorScheme.primary,
                  elevation: 6,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: toggleMenu,
                    child: SizedBox(
                      width: 68,
                      height: 68,
                      child: Center(
                        child: AnimatedIcon(
                          icon: AnimatedIcons.menu_close,
                          progress: _controller,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =====================================================
  // DISPOSE CONTROLLER
  // =====================================================
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
