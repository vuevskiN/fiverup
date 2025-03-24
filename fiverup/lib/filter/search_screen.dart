import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiverup/match/match_filter.dart';
import 'package:fiverup/service/applicationHistory_service.dart';
import 'package:fiverup/service/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../application_screen/lapplication_screen.dart';
import '../job/edit/edit_job.dart';
import '../models/job.dart';
import '../models/profile.dart';
import '../service/application_service.dart';
import '../service/job_service.dart';
import '../job/add/add_job.dart';
import '../service/notification_service.dart';
import '../service/profileImg_service.dart';


class SearchScreen extends StatefulWidget {

  final String searchQuery;



  SearchScreen({required this.searchQuery});



  @override

  _SearchScreenState createState() => _SearchScreenState();

}



class _SearchScreenState extends State<SearchScreen> {

  late TextEditingController _searchController;

  final JobService jobService = JobService();

  final ImageService profileImgService = ImageService();

  String? loggedInUser;

  String? userProfileImageUrl; // Store the user's profile image URL

  DateTime? _selectedDate;

  int _currentPage = 1;

  int _jobsPerPage = 10;

  int _totalJobs = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference imagesCollection = FirebaseFirestore.instance.collection('images');





  @override

  void initState() {

    super.initState();

    _searchController = TextEditingController(text: widget.searchQuery);

    _getLoggedInUser();

    _getTotalJobs();

  }





  Future<void> _getLoggedInUser() async {

    try {

      final user = FirebaseAuth.instance.currentUser;

      setState(() {

        loggedInUser = user?.email;

      });

      if (loggedInUser != null) {

        _fetchUserProfileImageUrl(loggedInUser!);

      }

    } catch (e) {

      print("Error getting logged-in user: $e");

    }

  }



  Future<String?> getUserProfileImage(String userId) async {

    try {



      QuerySnapshot snapshot = await imagesCollection.where('userId', isEqualTo: userId).get();

      if (snapshot.docs.isNotEmpty) {

        print("print: "+snapshot.docs.first['icon']);
        return snapshot.docs.first['icon']; // Return the icon name (string)

      }

    } catch (e) {
      print("Error fetching profile image: $e");
    }
    return null;
  }



  Future<void> _fetchUserProfileImageUrl(String email) async {

    final imageUrl = await profileImgService.getUserProfileImage(email);
    print("image:"+imageUrl!);
    setState(() {

      userProfileImageUrl = imageUrl; // Store the image URL

    });

  }



  Future<void> _getTotalJobs() async {

    try {

      final jobs = await jobService

          .getAllJobs()

          .first;

      setState(() {

        _totalJobs = jobs.length;

      });

    }

    catch (e) {

      print("Error fetching total jobs: $e");

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



// Method to handle next page navigation

  void _nextPage() {

    setState(() {

      _currentPage++;

    });

  }



  void fetchAndPrintAllImages() async {

    ImageService imageService = ImageService();

    await imageService.printAllImages();

  }





// Method to handle previous page navigation

  void _previousPage() {

    setState(() {

      if (_currentPage > 1) {

        _currentPage--;

      }

    });

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

              _buildPagination(),

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

          ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                final email = user?.email;
                if(email != null){
                  print("print email not null");
                  ProfileService profileService = ProfileService();

                  String? profileId = await profileService.getProfileByEmail(email);

                  if(profileId != null){
                    print("print profileId not null");
                    Profile? profile = await profileService.getProfileById(profileId);

                    if(profile != null){
                      print("print profile not null");
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> JobFilterScreen(profile: profile)));
                    }
                  }
                }
              },
              child: Text("Find Matches")),

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

      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),

      decoration: BoxDecoration(

        color: const Color(0xCC415A77),

        borderRadius: BorderRadius.circular(20),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(0.1),

            spreadRadius: 2,

            blurRadius: 8,

          ),

        ],

// color: const Color(0xCC415A77), // A deeper blue color for a modern feel

// borderRadius: BorderRadius.circular(20), // Rounded corners for a sleek design

// boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 2, blurRadius: 8)],

      ),

      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),

      child: Column(

        children: [

          SizedBox(height: 20), // Adjusted space between text and search bar



// Search Bar Container

          Container(

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius: BorderRadius.circular(30),

              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6, spreadRadius: 2)],

            ),

            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),

            child: Row(

              children: [

                Expanded(

                  child: TextField(

                    controller: _searchController,

                    decoration: InputDecoration(

                      hintText: 'Search for any service...',

                      hintStyle: TextStyle(

                        fontSize: 14,

                        color: Color(0xFF415A77),

                      ),

                      border: InputBorder.none,

                    ),

                    onSubmitted: (_) => _performSearch(), // Trigger search on submit

                  ),

                ),

                IconButton(

                  icon: Icon(Icons.search),

                  onPressed: _performSearch,

                  color: Colors.black,

                ),

              ],

            ),

          ),

        ],

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



// Pagination logic

        final startIndex = (_currentPage - 1) * _jobsPerPage;

        final endIndex = startIndex + _jobsPerPage;

        final paginatedJobs = filteredJobs.sublist(

          startIndex,

          endIndex > filteredJobs.length ? filteredJobs.length : endIndex,

        );



        return ListView.builder(

          shrinkWrap: true,

          physics: const NeverScrollableScrollPhysics(),

          itemCount: paginatedJobs.length,

          itemBuilder: (context, index) {

            final job = paginatedJobs[index];

            return _buildJobCard(job);

          },

        );

      },

    );

  }


  Widget _buildJobCard(Job job) {

    bool isUserCreator = loggedInUser == job.createdBy;

    String formattedDueDate = job.dueDate != null
        ? DateFormat('MMM dd, yyyy').format(job.dueDate!)
        : 'No due date';

    return Card(

      elevation: 6,

      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(16.0),

      ),

      child: Container(

        height: 180,

        padding: const EdgeInsets.all(16.0),

        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(16.0),

          color: const Color(0xFF0D1B2A), // Card background color

        ),

        child: Row(

          children: [


            job.createdBy == null

                ? const CircleAvatar(

              radius: 30,

              backgroundColor: Colors.white,

              child: Icon(

                Icons.person,

                color: Colors.black,

                size: 30,

              ),

            )

                : FutureBuilder<Profile?>(
                future: ProfileService().getProfileByEmailProfile(job.createdBy!),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: CircularProgressIndicator(),
                    );
                  }

                  if(snapshot.hasError || !snapshot.hasData || snapshot.data == null){
                    return const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 30,
                      ),
                    );
                  }

                  Profile profile = snapshot.data!;
                  return CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      _getIconFromName(profile.icons['avatarIcon'] ?? 'person'),
                      color: Colors.black,
                      size: 30,
                    ),
                  );
                },
            ),

            const SizedBox(width: 16),



// Right section with job details

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

// Job Title

                  Center(

                    child: Text(

                      job.title ?? 'No Title', // Handle nullable title

                      style: const TextStyle(

                        color: Colors.orange,

                        fontSize: 18,

                        fontWeight: FontWeight.w600,

                      ),

                    ),

                  ),

                  const SizedBox(height: 8),



// Offering/Seeking and Created By

                  Text(

                    job.offering ? 'Offering' : 'Seeking',

                    style: const TextStyle(

                      color: Colors.white70,

                      fontSize: 14,

                    ),

                  ),

                  const SizedBox(height: 4),

                  Text(

                    'Created By: ${job.createdBy ?? 'Unknown'}', // Handle nullable createdBy

                    style: const TextStyle(

                      color: Colors.white70,

                      fontSize: 14,

                    ),

                  ),

                  const SizedBox(height: 2,),
                  Text(
                    'Due Date $formattedDueDate',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const Spacer(),

// Second section with hourly rate and "+" icon

                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
// Left side: Hourly Rate
                      Text(
                        '\$${job.hourlyRate ?? 0}/hr', // Handle nullable hourlyRate
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

// Right side: "+" icon to show details
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => _buildJobDetailsDialog(
                              context,
                              job,
                              isUserCreator,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobDetailsDialog(BuildContext context, Job job, bool isUserCreator) {

    return Dialog(

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(16.0),

      ),

      child: Container(

        padding: const EdgeInsets.all(20.0),

        height: 350, // Increased height for better text positioning

        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(16.0),

          color: Colors.white, // Set the background to white

        ),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Center(

              child: Text(

                job.title,

                style: const TextStyle(

                  fontSize: 24,

                  fontWeight: FontWeight.bold,

                  color: Colors.black87,

                ),

              ),

            ),

            const SizedBox(height: 15),

            Text(

              'Created By: ${job.createdBy}',

              style: const TextStyle(

                fontSize: 16,

                color: Colors.black87,

                fontWeight: FontWeight.w500, // Slightly bold for better emphasis

              ),

            ),

            const SizedBox(height: 8),

            Text(

              'Description: ${job.description}',

              style: const TextStyle(

                fontSize: 16,

                color: Colors.black54, // Lighter color for description

              ),

            ),

            const SizedBox(height: 8),

            Text(

              'Hourly Rate: \$${job.hourlyRate}/hr',

              style: const TextStyle(

                fontSize: 16,

                color: Colors.black87,

                fontWeight: FontWeight.w500, // Bold for rate

              ),

            ),
            Text(
                'Location: ${job.location}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500
                ),
            ),
            Text(
                job.requiredSkills != null && job.requiredSkills!.isNotEmpty
                ? job.requiredSkills!.join(", ")
                : "No skills required"),

            const SizedBox(height: 8),

            Text(

              job.offering ? 'Offering' : 'Seeking',

              style: const TextStyle(

                fontSize: 16,

                color: Colors.blueAccent, // Blue color for offering/Seeking

                fontWeight: FontWeight.w500,

              ),

            ),

            const Spacer(),

            Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

// Button to Edit Job - Only shown for creator

                if (isUserCreator)

                  TextButton(

                    child: const Text(

                      'Edit',

                      style: TextStyle(

                        color: Colors.white, // White text on red background

                        fontWeight: FontWeight.w500,

                      ),

                    ),

                    onPressed: () {

                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditJobScreen(job: job)));

                    },

                    style: TextButton.styleFrom(

                      backgroundColor: Colors.orange, // Red background for Edit

                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(8),

                      ),

                    ),

                  ),

// Button to View Applicants - Only shown for creator

                if (isUserCreator)

                  TextButton(

                    child: const Text(

                      'View Applicants',

                      style: TextStyle(

                        color: Colors.white, // White text on green background

                        fontWeight: FontWeight.w500,

                      ),

                    ),

                    onPressed: () async {

                      final applicationService = ApplicationService();

                      final applications = await applicationService.fetchApplications(job.jobId);



                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (context) {

                            return ApplicantListScreen(

                              jobTitle: job.title,

                              applications: applications,

                            );

                          },

                        ),

                      );

                    },

                    style: TextButton.styleFrom(

                      backgroundColor: Colors.green, // Green background for View Applicants

                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(8),

                      ),

                    ),

                  ),

// Button to Apply - Only shown for non-creator

                if (!isUserCreator)

                  TextButton(

                    child: const Text(

                      'Close',

                      style: TextStyle(

                        color: Colors.white, // White text on red background

                        fontWeight: FontWeight.w500,

                      ),

                    ),

                    onPressed: () {

                      Navigator.of(context).pop();

                    },

                    style: TextButton.styleFrom(

                      backgroundColor: Colors.red, // Red background for Edit

                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(8),

                      ),

                    ),

                  ),

                if (!isUserCreator)

                  TextButton(

                    onPressed: () async {

                      if(job.offering) {
                        final applicationService = ApplicationService();

                        await applicationService.applyForJob(
                            job.jobId, job.createdBy!, job.hourlyRate,
                            job.title,
                            'pending'
                        );


                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(

                          const SnackBar(content: Text(
                              'You have applied for the job.')),
                        );
                      }

                      if (job.seeking) {
                        final applicationHistoryService = ApplicationHistoryService();
                        final notificationService = NotificationService();
                        final currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
                        final applicationService = ApplicationService();

                        await applicationHistoryService.logApplicationDecision(
                          job.createdBy!,
                          'accepted',
                          Timestamp.now(),
                          currentUserEmail,
                        );

                        await applicationService.applyForJob(
                            job.jobId,
                            currentUserEmail,
                            job.hourlyRate,
                            job.title,
                            'accepted'
                        );

                        await notificationService.sendNotification(
                          receiverEmail: job.createdBy!,
                          senderEmail: currentUserEmail,
                          status: 'accepted',
                        );

                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('You have applied for the job.')),
                        );
                      }
                    },

                    style: TextButton.styleFrom(

                      backgroundColor: Colors.blue, // Blue background for Apply

                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                      shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(8),

                      ),

                    ),

                    child: const Text(

                      'Apply',

                      style: TextStyle(

                        color: Colors.white, // White text on blue background

                        fontWeight: FontWeight.w500,

                      ),

                    ),

                  ),

              ],

            ),

          ],

        ),

      ),

    );

  }

  Widget _buildPagination() {

    return Padding(

      padding: const EdgeInsets.symmetric(vertical: 16.0),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          IconButton(

            icon: const Icon(Icons.arrow_back),

            onPressed: _currentPage > 1 ? _previousPage : null,

// Disable when on first page

            color: _currentPage > 1 ? Colors.black : Colors.grey,

          ),

          Text('Page $_currentPage'),

          IconButton(

            icon: const Icon(Icons.arrow_forward),

            onPressed: _currentPage < (_totalJobs / _jobsPerPage).ceil()

                ? _nextPage

                : null, // Disable when on last page

            color: _currentPage < (_totalJobs / _jobsPerPage).ceil()

                ? Colors.black

                : Colors.grey,

          ),

        ],

      ),

    );

  }

}

IconData _getIconFromName(String iconName) {
  switch (iconName) {
    case 'local_cafe_rounded':
      return Icons.local_cafe_rounded;
    case 'bug_report':
      return Icons.bug_report;
    case 'local_florist':
      return Icons.local_florist;
    case 'apple':
      return Icons.apple;
    case 'directions_bike':
      return Icons.directions_bike;
    default:
      return Icons.person;
  }
}