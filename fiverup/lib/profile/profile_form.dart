import 'package:flutter/material.dart';
import '../job/personal_jobs/my_offers.dart';
import '../job/personal_jobs/my_seeking.dart';
import '../main/main_page.dart';
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
        name: _nameController.text.trim(),
        profession: _professionController.text.trim(),
        about: _aboutController.text.trim(),
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyJobsPage()));
                },
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyOffersPage()));
                },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return 'Name must only contain letters and spaces';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Profession is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Profession must be at least 3 characters';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'About is required';
                      }
                      if (value.trim().length < 10) {
                        return 'About section must be at least 10 characters';
                      }
                      return null;
                    },
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
