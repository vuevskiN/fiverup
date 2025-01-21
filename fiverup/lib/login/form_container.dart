import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverup/main/main_page.dart';
import 'package:flutter/material.dart';

import '../new_profile/profile_creation.dart';
import '../profile/profile_screen.dart';


class FormContainerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: const Color(0xFF2C2C2C),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FormContainer(),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5), // Optional background color
    );
  }
}

  class FormContainer extends StatelessWidget {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    Future<bool> _checkProfileExists(String email) async {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot querySnapshot = await firestore
          .collection('profiles')
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    }
  // Function to sign in the user with Firebase
    Future<void> _signInUser(BuildContext context) async {
      try {
        print("Sign-In button clicked");
        final FirebaseAuth auth = FirebaseAuth.instance;
        final UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        print("User signed in: ${userCredential.user?.email}");

        final String email = userCredential.user!.email!;
        final bool profileExists = await _checkProfileExists(email);

        if (profileExists) {
          final String profileId = await _getProfileId(email);  // Fetch profile ID
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(), // Pass profileId here
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfileCreationPage(email: email)),
          );
        }
      } on FirebaseAuthException catch (e) {
        print("FirebaseAuthException: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred')),
        );
      }
    }

    Future<String> _getProfileId(String email) async {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final QuerySnapshot querySnapshot = await firestore
          .collection('profiles')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;  // Return the profile ID
      } else {
        throw Exception("Profile not found");
      }
    }



    @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFD9D9D9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmailInput(controller: emailController),
          SizedBox(height: 24),
          PasswordInput(controller: passwordController),
          SizedBox(height: 24),
          SignInButton(onPressed: () => _signInUser(context)),
        ],
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(12),
          backgroundColor: Color(0xFF2C2C2C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text('Sign In'),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;

  const PasswordInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(color: Color(0xFF000000)),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: 'Value',
            hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
          ),
          obscureText: true,
        ),
      ],
    );
  }
}

class EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const EmailInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(color: Color(0xFF000000)),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: 'Value',
            hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
          ),
        ),
      ],
    );
  }
}
