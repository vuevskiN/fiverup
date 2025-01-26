import 'package:fiverup/login/form_container.dart';
import 'package:fiverup/register/auth_screen.dart';
import 'package:flutter/material.dart';

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const SizedBox(height: 50),
        const Text(
          'Fast, quality assured, and affordable— find or offer the services you need.',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            fontFamily: 'Playfair Display',
            height: 22/18,
          ),
        ),
        const SizedBox(height: 69),
        const Text(
          'Join thousands of professionals delivering and finding exceptional services.\nStart connecting with global talent today!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
            height: 18/10,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AuthScreen()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B263B),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(141, 41),
          ),
          child: const Text(
            'Get Started',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              height: 29/16,
            ),
          ),
        ),
      ],
    );
  }
}