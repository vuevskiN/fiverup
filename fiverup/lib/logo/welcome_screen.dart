import 'package:fiverup/logo/widgets/welcome_content.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Make body extend behind AppBar
      appBar: AppBar(
        backgroundColor:
        Colors.transparent, // Make AppBar transparent to blend with background
        elevation: 0, // Remove AppBar shadow for a cleaner look
        title: Text(
          "FiverUp",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700, // Bold font weight
            fontStyle: FontStyle.normal, // Use normal font style
            fontFamily: 'Roboto', // Modern font
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(2, 2),
                blurRadius: 4,
              )
            ],// Add letter spacing for emphasis
          ),
        ),
        centerTitle: true, // Center the title
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1B2A),
              Color(0xFF203A4E),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 480),
                  margin: const EdgeInsets.symmetric(horizontal: 22),
                  padding: const EdgeInsets.only(top: 12, bottom: 20), // Adjust bottom padding
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/image.png',
                              width: 500,
                              height: 300,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const WelcomeContent(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}