import 'package:fiverup/main/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'button_section.dart';
import 'category_section.dart';
import 'header_section.dart';

class HomePage extends StatelessWidget {
  final String profileId;

  const HomePage({Key? key, required this.profileId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            HeaderSection(profileId: profileId),
            PromoSection(), // Displays the last 3 searches
            ButtonSection(),
            PopularSection(),
          ],
        ),
      ),
    );
  }
}
