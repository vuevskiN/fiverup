import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service/recent_service.dart';

class ButtonSection extends StatefulWidget {
  const ButtonSection({Key? key}) : super(key: key);

  @override
  _ButtonSectionState createState() => _ButtonSectionState();
}

class _ButtonSectionState extends State<ButtonSection> {
  late Future<List<String>> _recentSearches;

  @override
  void initState() {
    super.initState();
    _refreshSearchHistory(); // Refresh the search history immediately when the page loads
  }

  // Function to refresh the search history
  void _refreshSearchHistory() {
    setState(() {
      _recentSearches = getLast3Searches(); // Re-fetch the data to update the UI
    });
  }

  // Listen for changes when coming back from SearchScreen
  void _onSearchScreenRefresh() {
    _refreshSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _recentSearches, // Use the updated future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No recent searches found.'));
        }

        final recentSearches = snapshot.data!;

        return Column(
          children: recentSearches.map((search) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(search),
                onTap: () {
                  _refreshSearchHistory();
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
