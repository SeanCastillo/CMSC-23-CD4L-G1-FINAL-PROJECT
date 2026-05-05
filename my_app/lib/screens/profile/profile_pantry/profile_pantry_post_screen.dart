import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../providers/tags_provider.dart';
import '../widgets/profile_tags/tags_section.dart';

import '../../../../../providers/pantry_provider.dart';
import '../../../../../models/post_model.dart';

/// =====================================================
/// ENTRY WIDGET
/// =====================================================
class ProfilePantryPost extends StatelessWidget {
  final PantryPost? post;

  const ProfilePantryPost({super.key, this.post});

  @override
  Widget build(BuildContext context) {
    return _ProfilePantryPostView(post: post);
  }
}

/// =====================================================
/// MAIN VIEW (POST CREATION)
/// =====================================================
class _ProfilePantryPostView extends StatefulWidget {
  final PantryPost? post;

  const _ProfilePantryPostView({this.post});

  @override
  State<_ProfilePantryPostView> createState() => _ProfilePantryPostViewState();
}

class _ProfilePantryPostViewState extends State<_ProfilePantryPostView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  static const int maxDescriptionLength = 150;

  DateTime? expirationDate;
  XFile? _image;

  final ImagePicker _picker = ImagePicker();

  bool get isEdit => widget.post != null;

  /// =====================================================
  /// LOCAL TAG STATE (NO PROVIDER FOR SELECTED)
  /// =====================================================
  List<String> dietaryTags = [];
  List<String> interestTags = [];

  /// =====================================================
  /// INIT (PREFILL FOR EDIT)
  /// =====================================================
  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final post = widget.post!;

      _titleController.text = post.title;
      _descriptionController.text = post.description;
      expirationDate = post.expiration;
      _image = XFile(post.imagePath);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final tagsProvider = context.read<TagsProvider>();

        setState(() {
          dietaryTags = post.tags
              .where((tag) => tagsProvider.dietaryOptions.contains(tag))
              .toList();

          interestTags = post.tags
              .where((tag) => tagsProvider.interestOptions.contains(tag))
              .toList();
        });
      });
    }
  }

  /// =====================================================
  /// IMAGE PICKER + CROP
  /// =====================================================
  Future<void> pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (picked == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: true),
      ],
    );

    if (cropped != null) {
      setState(() {
        _image = XFile(cropped.path);
      });
    }
  }

  /// =====================================================
  /// DATE PICKER
  /// =====================================================
  Future<void> pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: expirationDate ?? today,
      firstDate: today, // no past dates allowed 11!1!!11!
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        expirationDate = picked;
      });
    }
  }

  /// =====================================================
  /// SUBMIT (CREATE / UPDATE)
  /// =====================================================
  void submitPost() {
    final title = _titleController.text;

    if (_image == null ||
        title.isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        expirationDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Photo, title, and expiration date are required"),
        ),
      );
      return;
    }

    final allTags = [...dietaryTags, ...interestTags];

    final pantry = context.read<PantryProvider>();

    if (isEdit) {
      //  --- UPDATE ---
      pantry.updatePost(
        PantryPost(
          id: widget.post!.id,
          title: title,
          description: _descriptionController.text.trim(),
          expiration: expirationDate!,
          tags: allTags,
          imagePath: _image!.path,
        ),
      );
    } else {
      // --- CREATE ---
      pantry.addPost(
        PantryPost(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          description: _descriptionController.text.trim(),
          expiration: expirationDate!,
          tags: List.from(allTags),
          imagePath: _image!.path,
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // =====================================================
  // UI
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Pantry Post" : "Create Pantry Post"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- IMAGE ---
              AspectRatio(
                aspectRatio: 1,
                child: GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _image == null
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, size: 40),
                                SizedBox(height: 8),
                                Text("Take Photo"),
                              ],
                            ),
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(_image!.path),
                                  key: ValueKey(_image!.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.crop,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- TITLE ---
              const Text(
                "Title",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),

              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: InputDecoration(
                  hintText: "What are you sharing? (e.g. eggs)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText: "",
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _titleController,
                  builder: (context, value, _) {
                    final length = value.text.length;

                    return AnimatedOpacity(
                      opacity: length > 0 ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        "$length / 50",
                        style: TextStyle(
                          fontSize: 12,
                          color: length > 40 ? Colors.orange : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 6),

              // --- DESCRIPTION ---
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),

              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _descriptionController,
                        maxLength: maxDescriptionLength,
                        minLines: 3,
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                        scrollPhysics: const BouncingScrollPhysics(),
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: "Tell us a little about this item...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          counterText: "",
                        ),
                      ),

                      // --- CUSTOM COUNTER ---
                      Align(
                        alignment: Alignment.centerRight,
                        child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _descriptionController,
                          builder: (context, value, _) {
                            final length = value.text.length;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: length > maxDescriptionLength * 0.8
                                    ? Colors.orange.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "$length / $maxDescriptionLength",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: length > maxDescriptionLength * 0.8
                                      ? Colors.orange
                                      : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- EXPIRATION ---
              const Text(
                "Expiration Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),

              GestureDetector(
                onTap: pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        expirationDate == null
                            ? "Select date"
                            : DateFormat('MMM d, yyyy').format(expirationDate!),
                      ),
                      const Icon(Icons.calendar_today, size: 18),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- TAGS ---
              const Text("Tags", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),

              TagsSection(
                dietaryTags: dietaryTags,
                interestTags: interestTags,
                onDietaryChanged: (tags) {
                  setState(() => dietaryTags = tags);
                },
                onInterestChanged: (tags) {
                  setState(() => interestTags = tags);
                },
              ),

              const SizedBox(height: 30),

              // SUBMIT
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitPost,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    isEdit ? "Update Item" : "Post Item",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
