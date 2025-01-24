import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main/main_page.dart';

class ProfileCreationPage extends StatelessWidget {
  final String email;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  ProfileCreationPage({required this.email});

  Future<void> _createProfile(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
        backgroundColor: const Color(0xFF2C2C2C),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: professionController,
              decoration: InputDecoration(labelText: 'Profession'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: aboutController,
              decoration: InputDecoration(labelText: 'About'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _createProfile(context),
              child: Text('Save Profile'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Color(0xFF2C2C2C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
