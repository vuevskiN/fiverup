import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../application_screen/lapplication_screen.dart';
import '../job/edit/edit_job.dart';
import '../models/job.dart';
import '../service/application_service.dart';
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
  DateTime? _selectedDate;

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

  // Method to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // Default to today
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Update the selected date
      });
    }
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
              // Button to trigger date picker
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    _selectedDate == null
                        ? 'Pick a Date'
                        : 'Selected Date: ${_selectedDate!.toLocal()}'.split(
                        ' ')[0],
                  ),
                ),
              ),
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
    bool isUserCreator = loggedInUser == job.createdBy;

    return GestureDetector(
      onTap: () {
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
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  if (isUserCreator)
                    TextButton(
                      child: const Text('View Applicants'),
                      onPressed: () async {
                        final applicationService = ApplicationService();
                        final applications = await applicationService
                            .fetchApplications(job.jobId);

                       // Navigator.of(context).pop();
                        // Navigate to a new screen to show the list of applicants
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              print("Navigating to ApplicantListScreen");
                              return ApplicantListScreen(
                                jobTitle: job.title,
                                applications: applications,
                              );
                            },
                          ),
                        );
                      },
                    )
                  else
                    TextButton(
                      child: const Text('Apply'),
                      onPressed: () async {
                        final applicationService = ApplicationService();
                        await applicationService.applyForJob(
                            job.jobId, job.createdBy!);

                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('You have applied for the job.')),
                        );
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
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.offering ? 'Offering' : 'Seeking',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                job.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}