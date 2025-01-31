import 'package:flutter/material.dart';
import 'widgets/signup_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D1B2A),
          title: Center(
            child: Text(
              'Fiver Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),

        body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.only(bottom: 174),
          child: Column(
            children: [
              const SizedBox(height: 110),
              const SignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}