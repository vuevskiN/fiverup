// models.dart
class Job {
  final String title;
  final String description;
  final double hourlyRate;

  Job({required this.title, required this.description, required this.hourlyRate});
}

// Pre-made jobs
final List<Job> preMadeJobs = [
  Job(
    title: "Web Developer",
    description: "Looking for a skilled developer to build a website.",
    hourlyRate: 25.0,
  ),
  Job(
    title: "Graphic Designer",
    description: "Need a designer for logo and branding materials.",
    hourlyRate: 20.0,
  ),
];
