import 'package:fiverup/profile/profile_form.dart';
import 'package:fiverup/profile/profile_header.dart';
import 'package:fiverup/profile/profile_info.dart';
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
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF0D1B2A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              FutureBuilder<Profile?>(
                future: Provider.of<ProfileService>(context, listen: false)
                    .getProfileById(profileId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error fetching profile: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: Text('No Profile Found. Please try again later.'),
                    );
                  }

                  final profile = snapshot.data!;

                  return Column(
                    children: [
                      ProfileInfoScreen(profile: profile),
                      const SizedBox(height: 20),
                      ProfileForm(profile: profile, profileId: profileId),
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