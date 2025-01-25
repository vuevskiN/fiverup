import 'package:flutter/material.dart';
import '../main/main_page.dart';
import '../models/profile.dart'; // Import Profile model
import '../service/profileImg_service.dart';
import '../service/profile_service.dart';

class ProfileForm extends StatefulWidget {
  final Profile profile;
  final String profileId;

  const ProfileForm({Key? key, required this.profile, required this.profileId})
      : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _aboutController;
  final ProfileService _profileService = ProfileService();
  final ImageService _imageService = ImageService(); // Initialize ImageService
  String? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _professionController = TextEditingController(text: widget.profile.profession);
    _aboutController = TextEditingController(text: widget.profile.about);
    _selectedIcon = widget.profile.avatarUrl; // Set initial icon if any
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  // Update the profile with the selected image icon
  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = Profile(
        id: widget.profile.id,
        name: _nameController.text.trim(),
        profession: _professionController.text.trim(),
        about: _aboutController.text.trim(),
        imageUrl: widget.profile.imageUrl,
        avatarUrl: _selectedIcon ?? widget.profile.avatarUrl, // Use selected icon
      );

      await _profileService.updateProfile(widget.profile.id, updatedProfile);

      // Update image icon if selected
      if (_selectedIcon != null) {
        await _imageService.updateProfileImageIcon(widget.profile.id, _selectedIcon!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(profileId: widget.profileId),
        ),
      );
    }
  }

  // Image selection function
  Future<void> _selectImage() async {
    // This can be replaced with an image picker or dropdown for selecting icons
    final newIcon = await _showIconPickerDialog();
    if (newIcon != null) {
      setState(() {
        _selectedIcon = newIcon;
      });
    }
  }

  Future<String?> _showIconPickerDialog() async {
    // Example of an icon selection dialog
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select an Icon'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Icon 1'),
                onTap: () => Navigator.pop(context, 'icon1.png'),
              ),
              ListTile(
                title: const Text('Icon 2'),
                onTap: () => Navigator.pop(context, 'icon2.png'),
              ),
              ListTile(
                title: const Text('Icon 3'),
                onTap: () => Navigator.pop(context, 'icon3.png'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _professionController,
              decoration: InputDecoration(
                labelText: 'Profession',
                labelStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Profession is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _aboutController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'About',
                labelStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'About is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectImage, // Trigger image selection
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFF2C2C2C),
                minimumSize: const Size(100, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Select Image',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFF2C2C2C),
                minimumSize: const Size(100, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Update Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
