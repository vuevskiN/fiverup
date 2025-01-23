import 'package:fiverup/main/main_page.dart';
import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../service/profile_service.dart';

class ProfileForm extends StatefulWidget {
  final Profile profile;
  final String profileId;

  const ProfileForm({super.key, required this.profile, required this.profileId});



  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _aboutController;
  final ProfileService _profileService = ProfileService();


  @override
  void initState() {
    super.initState();
    // Initialize controllers with current profile data
    _nameController = TextEditingController(text: widget.profile.name);
    _professionController = TextEditingController(text: widget.profile.profession);
    _aboutController = TextEditingController(text: widget.profile.about);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      // Create an updated Profile object
      final updatedProfile = Profile(
        id: widget.profile.id,
        name: _nameController.text,
        profession: _professionController.text,
        about: _aboutController.text,
        imageUrl: widget.profile.imageUrl,
        avatarUrl: widget.profile.avatarUrl,
      );

      // Call the updateProfile method in ProfileService
      await _profileService.updateProfile(widget.profile.id, updatedProfile);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      // Navigate to another page after success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(profileId: widget.profileId), // Replace with your target page
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 46),
      width: 383,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {}, // Add functionality if needed
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C2C2C),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Edit Profile'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {}, // Add functionality if needed
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Color(0xFF2C2C2C)),
                ),
                child: const Text('My Jobs'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {}, // Add functionality if needed
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Color(0xFF2C2C2C)),
                ),
                child: const Text('My Offers'),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 19),
            padding: const EdgeInsets.all(14),
            width: 219,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Name'),
                  const SizedBox(height: 9),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 15),
                  const Text('Profession'),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _professionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Profession is required' : null,
                  ),
                  const SizedBox(height: 15),
                  const Text('About'),
                  const SizedBox(height: 11),
                  TextFormField(
                    controller: _aboutController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'About is required' : null,
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5A000),
                        minimumSize: const Size(72, 28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(color: Color(0xFFBF6A02)),
                        ),
                      ),
                      child: const Text('Update'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
