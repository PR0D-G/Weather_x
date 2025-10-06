class Job {
  final String title;
  final List<String> skills;

  Job({
    required this.title,
    required this.skills,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      title: json['title'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'skills': skills,
    };
  }
}
