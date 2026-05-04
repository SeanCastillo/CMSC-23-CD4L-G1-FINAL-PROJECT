import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// fix: 4 levels up from lib/screens/profile/screens/profile_settings/
import '../../../../theme/app_colors.dart';
import '../../../../widgets/glass_container.dart';

// fix: 2 levels up to lib/screens/profile/
import '../../widgets/base_profile_layout.dart';
import '../../providers/profile_provider.dart';

// =====================================================
// USER SETTINGS PAGE
// light glass styling — logic unchanged from original
// =====================================================
class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _name;
  late TextEditingController _userName;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    _name = TextEditingController(text: profile.name);
    _userName = TextEditingController(text: profile.userName);
    if (profile.imagePath != null) {
      _imageFile = File(profile.imagePath!);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _userName.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.blush,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Change Photo',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _SheetTile(
                  icon: Icons.camera_alt_outlined,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 8),
                _SheetTile(
                  icon: Icons.photo_library_outlined,
                  label: 'Photo Library',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeImage() => setState(() => _imageFile = null);

  void _saveProfile() {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    profile.updateProfile(
      name: _name.text.trim(),
      userName: _userName.text.trim(),
      imagePath: _imageFile?.path,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BaseProfileLayout(
          title: 'Edit Profile',
          showBackButton: true,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =====================================================
                // AVATAR SECTION (glass card)
                // =====================================================
                GlassContainer(
                  width: double.infinity,
                  borderRadius: 22,
                  blur: 12,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // avatar preview
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.blush, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.maroon.withValues(alpha: 0.12),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: AppColors.blush,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : const AssetImage('assets/profile.jpg')
                                  as ImageProvider,
                        ),
                      ),

                      const SizedBox(width: 18),

                      // actions
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ActionBtn(
                              label: 'Change picture',
                              isPrimary: true,
                              onTap: _showImageSourceSheet,
                            ),
                            const SizedBox(height: 8),
                            _ActionBtn(
                              label: 'Remove picture',
                              isPrimary: false,
                              onTap: _removeImage,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =====================================================
                // INPUT FIELDS
                // =====================================================
                const _FieldLabel('Full Name'),
                const SizedBox(height: 6),
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    hintText: 'Your display name',
                  ),
                ),

                const SizedBox(height: 16),

                const _FieldLabel('Username'),
                const SizedBox(height: 6),
                TextField(
                  controller: _userName,
                  decoration: InputDecoration(
                    hintText: 'e.g. janedoe',
                    prefixText: '@',
                    prefixStyle: GoogleFonts.nunito(
                      color: AppColors.tan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // =====================================================
                // SAVE BUTTON
                // =====================================================
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save Profile'),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// FIELD LABEL
// =====================================================
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
        letterSpacing: 0.06,
      ),
    );
  }
}

// =====================================================
// ACTION BUTTON (in avatar card)
// =====================================================
class _ActionBtn extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 14),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.maroon : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPrimary ? AppColors.maroon : AppColors.blush,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isPrimary ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

// =====================================================
// BOTTOM SHEET TILE
// =====================================================
class _SheetTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          // fix: withOpacity → withValues
          color: Colors.white.withValues(alpha: 0.60),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.blush, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.maroon, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}