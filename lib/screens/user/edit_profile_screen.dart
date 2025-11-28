// lib/screens/user/edit_profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load existing saved values (name, email, image path)
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;
    setState(() {
      _nameController.text = prefs.getString("user_name") ?? "Jordan Walube";
      _emailController.text = prefs.getString("user_email") ?? "jordan@example.com";
    });

    final savedPath = prefs.getString("user_image");
    if (savedPath != null) {
      final f = File(savedPath);
      if (await f.exists()) {
        if (!mounted) return;
        setState(() => _imageFile = f);
      } else {
        // file doesn't exist: clear saved key so it doesn't keep pointing to missing file
        await prefs.remove("user_image");
      }
    }
  }

  // Pick an image and copy it into the app documents folder (permanent)
  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      // Get application documents directory
      final appDir = await getApplicationDocumentsDirectory();

      // Use a unique filename so we don't overwrite unexpectely
      final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${extensionFromPath(picked.path)}';
      final File savedImage = await File(picked.path).copy('${appDir.path}/$fileName');

      if (!mounted) return;
      setState(() {
        _imageFile = savedImage;
      });
    } catch (e) {
      // optionally show a snack / print error for debugging
      debugPrint('Error picking image: $e');
    }
  }

  // Helper to preserve file extension from original path
  String extensionFromPath(String path) {
    final int dot = path.lastIndexOf('.');
    if (dot == -1) return '.jpg';
    return path.substring(dot);
  }

  // Save name, email, and image path (if available)
  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("user_name", _nameController.text.trim());
    await prefs.setString("user_email", _emailController.text.trim());

    if (_imageFile != null) {
      await prefs.setString("user_image", _imageFile!.path);
    } else {
      // optional: remove key if user cleared image
      await prefs.remove("user_image");
    }

    // go back and let caller refresh
    if (mounted) Navigator.pop(context);
  }

  // Optional: allow user to remove current image
  Future<void> _removeImage() async {
    if (_imageFile == null) return;
    final prefs = await SharedPreferences.getInstance();

    // delete file from disk if exists
    try {
      final f = _imageFile!;
      if (await f.exists()) {
        await f.delete();
      }
    } catch (e) {
      debugPrint('Error deleting image file: $e');
    }

    await prefs.remove("user_image");

    if (!mounted) return;
    setState(() => _imageFile = null);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // Image + actions
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.black45)
                      : null,
                ),
              ),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: InkWell(
                    onTap: _removeImage,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.close, size: 18, color: Colors.red.shade700),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Name
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),

          const SizedBox(height: 16),

          // Email
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
            ),
          ),
        ]),
      ),
    );
  }
}
