import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../main/main_page.dart';

class ProfileCreationPage extends StatefulWidget {
  final String email;

  ProfileCreationPage({required this.email});

  @override
  _ProfileCreationPageState createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController skillsController = TextEditingController(); // Controller for skills
  final _formKey = GlobalKey<FormState>(); // Global key for the form

  List<String> skills = []; // List to store skills

  Future<void> _createProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Form inputs are valid
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final docRef = firestore.collection('profiles').doc();

      try {
        await docRef.set({
          'email': widget.email,
          'name': nameController.text.trim(),
          'profession': professionController.text.trim(),
          'about': aboutController.text.trim(),
          'imageUrl': '', // Placeholder for image URL
          'skills': skills, // Store the skills list
        });

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

  // Method to handle skill input and update the skills list
  void _addSkill() {
    final skill = skillsController.text.trim();
    if (skill.isNotEmpty && !skills.contains(skill)) {
      setState(() {
        skills.add(skill);
        skillsController.clear();
      });
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
              SizedBox(height: 16),
              // Skills Input Field
              TextFormField(
                controller: skillsController,
                decoration: InputDecoration(labelText: 'Add Skill'),
                onFieldSubmitted: (value) => _addSkill(),
              ),
              SizedBox(height: 8),
              // Display list of added skills
              Wrap(
                spacing: 8,
                children: skills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    onDeleted: () {
                      setState(() {
                        skills.remove(skill);
                      });
                    },
                  );
                }).toList(),
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
