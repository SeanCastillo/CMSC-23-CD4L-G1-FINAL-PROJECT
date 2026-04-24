import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'profile_provider.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _bio;

  @override
  void initState() {
    super.initState();

    // =====================================================
    // LOAD PROFILE DATA FROM PROVIDER
    // =====================================================
    final profile =
        Provider.of<ProfileProvider>(context, listen: false);

    _firstName = TextEditingController(text: profile.firstName);
    _lastName = TextEditingController(text: profile.lastName);
    _bio = TextEditingController(text: profile.bio);

    // profile image init
    if (profile.imagePath != null) {
      _imageFile = File(profile.imagePath!);
    }
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _bio.dispose();
    super.dispose();
  }

  // =====================================================
  // IMAGE PICKER FUNCTIONS
  // =====================================================

  /// --- FUNCTION: pick image ---
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // --- FUNCTION: select whether pfp comes from camera or gallery ---
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

  // --- FUNCTION: remove pfp ---
  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  // =====================================================
  // SAVE PROFILE TO PROVIDER
  // =====================================================
  void _saveProfile() {
    final profile =
        Provider.of<ProfileProvider>(context, listen: false);

    profile.updateProfile(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      bio: _bio.text.trim(),
      imagePath: _imageFile?.path,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // --- APP BAR ---
      appBar: AppBar(title: const Text("Edit Profile")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            // =====================================================
            // PROFILE IMAGE SECTION
            // =====================================================
            Row(
              children: [

                // --- PROFILE PICTURE ---
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : const AssetImage("assets/profile.jpg")
                          as ImageProvider,
                ),

                const SizedBox(width: 20),

                // --- IMAGE ACTION BUTTONS ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // change picture button
                      ElevatedButton(
                        onPressed: _showImageSourceSheet,
                        child: const Text("Change picture"),
                      ),

                      const SizedBox(height: 10),

                      // delete picture button
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
            // TEXT INPUT FIELDS
            // =====================================================

            TextField(
              controller: _firstName,
              decoration: const InputDecoration(
                labelText: "First name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: _lastName,
              decoration: const InputDecoration(
                labelText: "Last name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: _bio,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Bio",
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
          ],
        ),
      ),
    );
  }
}