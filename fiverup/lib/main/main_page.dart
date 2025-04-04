import 'package:fiverup/main/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../filter/search_screen.dart';
import 'category_section.dart';
import 'comment_section.dart';
import 'header_section.dart';

class HomePage extends StatefulWidget {
  final String profileId;

  const HomePage({Key? key, required this.profileId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    _refreshSearchHistory();
  }

  void _refreshSearchHistory() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            HeaderSection(profileId: widget.profileId),
            PromoSection(), // Displays the last 3 searches
            PopularSection(),
            CommentSection(),
          ],
        ),
      ),
    );
  }

}
