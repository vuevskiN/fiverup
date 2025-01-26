import 'package:fiverup/logo/widgets/welcome_content.dart';
import 'package:flutter/material.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0D1B2A),
          title: Text(
              "FiverUp",
              style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                fontFamily: 'Playfair Display',
              ),

          ),
        ),
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          margin: const EdgeInsets.symmetric(horizontal: 22),
          padding: const EdgeInsets.only(top: 12, bottom: 71),
          child: Column(
            children: [

              Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20), // Adjust the top margin here
                child: Image.asset(
                  'assets/image.png',
                  width: 500,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),

              const WelcomeContent(),
            ],
          ),
        ),
      ),
    );
  }
}