import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/profile/base_profile_layout.dart';
import '../../../providers/profile_provider.dart';

// =====================================================
// USER SETTINGS PAGE
// =====================================================
class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

// =====================================================
// LOCAL STATE
// =====================================================
class _UserSettingsPageState extends State<UserSettingsPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _name;
  late TextEditingController _userName;

  @override
  void initState() {
    super.initState();

    // initialize from provider
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

  // =====================================================
  // IMAGE PICKER
  // =====================================================
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // =====================================================
  // IMAGE SOURCE SELECTION SHEET
  // =====================================================
  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // --- CAMERA OPTION ---
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              // --- GALLERY OPTION ---
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // =====================================================
  // REMOVE PROFILE IMAGE
  // =====================================================
  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  // =====================================================
  // SAVE PROFILE
  // =====================================================
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
          // =====================================================
          // HEADER
          // =====================================================
          title: "Edit Profile",
          showBackButton: true,

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =====================================================
                // PROFILE IMAGE SECTION
                // =====================================================
                Row(
                  children: [
                    // --- AVATAR PREVIEW ---
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : const AssetImage("assets/profile.jpg")
                                as ImageProvider,
                    ),

                    const SizedBox(width: 20),

                    // --- IMAGE ACTIONS ---
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // change pic
                          ElevatedButton(
                            onPressed: _showImageSourceSheet,
                            child: const Text("Change picture"),
                          ),
                          const SizedBox(height: 10),
                          // del pic
                          ElevatedButton(
                            onPressed: _removeImage,
                            child: const Text("Delete picture"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // =====================================================
                // INPUT FIELDS
                // =====================================================
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: "Full name",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: _userName,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                // =====================================================
                // SAVE BUTTON
                // =====================================================
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text("Save Profile"),
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
