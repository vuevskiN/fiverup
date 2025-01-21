import 'package:fiverup/profile/profile_form.dart';
import 'package:fiverup/profile/profile_header.dart';
import 'package:fiverup/profile/profile_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/profile.dart';
import '../service/profile_service.dart';

class ProfileScreen extends StatelessWidget {
  final String profileId;

  const ProfileScreen({Key? key, required this.profileId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.only(bottom: 165),
          child: Column(
            children: [
              // Fetch profile data using ProfileService
              FutureBuilder<Profile?>(
                future: Provider.of<ProfileService>(context, listen: false)
                    .getProfileById(profileId), // Use profileId here
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final profile = snapshot.data;

                  if (profile == null) {
                    return const Center(child: Text('No Profile Found'));
                  }

                  // Pass the profile data to each widget
                  return Column(
                    children: [
                      ProfileHeader(profile: profile),
                      ProfileInfo(profile: profile),
                      ProfileForm(profile: profile),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
