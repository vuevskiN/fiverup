import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfileHeader extends StatelessWidget {
  final Profile profile;

  const ProfileHeader({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          width: 86,
          color: const Color(0xFF0D1B2A),
          padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 4),
          child: const Text(
            'Go back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'Playfair Display',
              letterSpacing: 0.66,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        Stack(
          alignment: Alignment.center,
          children: [

            Container(
              margin: const EdgeInsets.only(top: 86, bottom: 51),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(profile.imageUrl), // Use the profile image URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Avatar Image (if you have an avatar URL)
            Positioned(
              bottom: 0,
              right: 24,
              child: profile.imageUrl.isNotEmpty
                  ? Image.network(
                profile.imageUrl,
                width: 25,
                height: 25,
              )
                  : Container(),
            ),
          ],
        ),
      ],
    );
  }
}
