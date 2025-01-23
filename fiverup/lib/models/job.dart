class Job {
  final String jobId;
  final String title;
  final String description;
  final double hourlyRate;
  final String? createdBy;
  bool seeking; // New field: true if the job is seeking, false otherwise
  bool offering; // New field: true if the job is offering, false otherwise

  Job({
    required this.jobId,
    required this.title,
    required this.description,
    required this.hourlyRate,
    this.createdBy,
    required this.seeking,
    required this.offering,
  }) {
    // Ensure seeking and offering can't both be true
    if (seeking == offering) {
      throw ArgumentError('Both seeking and offering cannot be true at the same time.');
    }
  }

  // Factory constructor for converting data from Firestore to Job object
  factory Job.fromFirestore(String id, Map<String, dynamic> data) {
    return Job(
      jobId: id,
      title: data['title'],
      description: data['description'],
      hourlyRate: data['hourlyRate'],
      createdBy: data['createdBy'],
      seeking: data['seeking'] ?? true,  // Default to false if not provided
      offering: data['offering'] ?? false, // Default to false if not provided
    );
  }

  // Convert Job object to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'hourlyRate': hourlyRate,
      'createdBy': createdBy,
      'seeking': seeking,
      'offering': offering,
    };
  }
}
