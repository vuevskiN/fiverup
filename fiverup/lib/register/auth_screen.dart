import 'package:flutter/material.dart';
import '../login/form_container.dart';
import 'widgets/auth_header.dart';
import 'widgets/signup_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.only(bottom: 174),
          child: Column(
            children: [
              const AuthHeader(),
              const SizedBox(height: 110),
              const SignupForm(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FormContainerPage()),
                  );
                },
                child: const Center(
                  child: Text("Already have an account? Log In"),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}