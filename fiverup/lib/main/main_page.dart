import 'package:fiverup/main/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../filter/search_screen.dart';
import '../service/recent_service.dart';
import 'button_section.dart';
import 'category_section.dart';
import 'header_section.dart';

class HomePage extends StatefulWidget {
  final String profileId;

  const HomePage({Key? key, required this.profileId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<String>> _recentSearches;

  @override
  void initState() {
    super.initState();
    _refreshSearchHistory(); // Refresh the search history when the page loads
  }

  // Function to refresh the search history
  void _refreshSearchHistory() {
    setState(() {
      _recentSearches = getLast3Searches(); // Re-fetch the data to update the UI
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
            ButtonSection(), // ButtonSection will be updated on state changes
            PopularSection(),
          ],
        ),
      ),
    );
  }


  // You can call this method in the onPressed function of the back button
  Future<void> _onBackPressed() async {
    // Navigate back and await the result (true or false)
    final shouldRefresh = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SearchScreen(searchQuery: '')),
    );

    // If true, refresh the search history
    if (shouldRefresh == true) {
      _refreshSearchHistory();
    }
  }
}
