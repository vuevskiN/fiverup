import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../job/edit/edit_job.dart';
import '../models/job.dart';
import '../service/job_service.dart';
import '../job/add/add_job.dart';


class SearchScreen extends StatefulWidget {
  final String searchQuery;

  SearchScreen({required this.searchQuery});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  final JobService jobService = JobService();
  String? loggedInUser; // Store the logged-in user

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _getLoggedInUser(); // Get logged-in user on screen load
  }

  Future<void> _getLoggedInUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      setState(() {
        loggedInUser = user?.email; // Get the email of the logged-in user
      });
    } catch (e) {
      print("Error getting logged-in user: $e");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(searchQuery: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.only(bottom: 13),
          child: Column(
            children: [
              _buildAppBar(context),
              _buildSearchBar(),
              _buildJobList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFF0D1B2A),
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          // Back arrow button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back to the previous page
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E1DD)),
              ),
              child: const Text(
                'FiverUP',
                style: TextStyle(
                  color: Color(0xFFE0E1DD),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Playfair Display',
                  letterSpacing: 0.66,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddJobScreen()),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildCircularButton(String iconPath) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            iconPath,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 19),
      padding: const EdgeInsets.symmetric(horizontal: 37, vertical: 28),
      decoration: BoxDecoration(
        color: const Color(0xCC415A77),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDADBDD)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for consulting services...',
                  hintStyle: TextStyle(
                    color: Color(0xFF1B263B),
                    fontSize: 11,
                    fontFamily: 'Inter',
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _performSearch(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _performSearch,
              color: Color(0xFF1B263B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobList() {
    return StreamBuilder<List<Job>>(
      stream: jobService.getAllJobs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No jobs found.'));
        }

        // Filter jobs based on the search query
        final filteredJobs = snapshot.data!.where((job) {
          final query = widget.searchQuery.toLowerCase();
          return job.title.toLowerCase().contains(query) ||
              job.createdBy!.toLowerCase().contains(
                  query); // Use useremail instead of description
        }).toList();

        if (filteredJobs.isEmpty) {
          return const Center(child: Text('No results for your search.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredJobs.length,
          itemBuilder: (context, index) {
            final job = filteredJobs[index];
            return _buildJobCard(job);
          },
        );
      },
    );
  }

  Widget _buildJobCard(Job job) {
    bool isUserCreator = loggedInUser ==
        job.createdBy; // Check if logged-in user created the job

    return GestureDetector(
      onTap: () {
        // Show a dialog with job details when the card is tapped
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text(job.title),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text('Created By: ${job.createdBy}'),
                      Text('Description: ${job.description}'),
                      Text('Hourly Rate: \$${job.hourlyRate}/hr'),
                      Text(job.offering ? 'Offering' : 'Seeking'),
                      // Add any other job details you'd like to display
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
          ),
          child: Stack(
            children: [
              // Background (Black Rectangle)
              Container(
                width: double.infinity,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.0)),
                ),
              ),

              // Job Title
              Positioned(
                top: 16,
                left: 16,
                child: Text(
                  job.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Display User Email (instead of Description)
              Positioned(
                left: 16,
                bottom: 40,
                child: Text(
                  job.offering ? 'Offering' : 'Seeking',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Hourly Rate
              Positioned(
                left: 16,
                bottom: 16,
                child: Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 20,
                      color: Colors.black54,
                    ),
                    Text(
                      "\$${job.hourlyRate}/hr",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Edit/Apply Button
              if (isUserCreator) // Show edit button only if the user is the creator
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    onPressed: () {
                      print('Navigating to Edit Screen for job: ${job.title}');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditJobScreen(job: job),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    color: Colors.white,
                    iconSize: 24,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}