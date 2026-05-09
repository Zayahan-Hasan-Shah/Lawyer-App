class InternshipModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String duration;
  final String stipend;
  final String description;
  final List<String> requirements;
  final String postedDate;

  InternshipModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.duration,
    required this.stipend,
    required this.description,
    required this.requirements,
    required this.postedDate,
  });
}