import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../main/main_page.dart';

class ProfileCreationPage extends StatelessWidget {
  final String email;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  ProfileCreationPage({required this.email});

  final _formKey = GlobalKey<FormState>(); // Global key for the form

  Future<void> _createProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Form inputs are valid
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Generate a document ID
      final docRef = firestore.collection('profiles').doc();

      try {
        await docRef.set({
          'email': email,
          'name': nameController.text.trim(),
          'profession': professionController.text.trim(),
          'about': aboutController.text.trim(),
          'imageUrl': '', // Placeholder for image URL
        });

        // Navigate to the HomePage with the new profileId
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(profileId: docRef.id),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
        backgroundColor: const Color(0xFF0D1B2A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey, // Associate the form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: professionController,
                decoration: InputDecoration(labelText: 'Profession'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Profession is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: aboutController,
                decoration: InputDecoration(labelText: 'About'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'About is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _createProfile(context),
                child: Text('Save Profile'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Color(0xFF2C2C2C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
