class CertificationModel {
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String certificateImage;
  final bool isCompleted;
  final String duration;
  final String instructor;
  final String level;
  final List<String> skills;

  CertificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.certificateImage,
    required this.isCompleted,
    required this.duration,
    required this.instructor,
    required this.level,
    required this.skills,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      certificateImage: json['certificateImage'] as String,
      isCompleted: json['isCompleted'] as bool,
      duration: json['duration'] as String,
      instructor: json['instructor'] as String,
      level: json['level'] as String,
      skills: (json['skills'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'certificateImage': certificateImage,
      'isCompleted': isCompleted,
      'duration': duration,
      'instructor': instructor,
      'level': level,
      'skills': skills,
    };
  }
}

class AllCertificationsResponse {
  final List<CertificationModel> completedCertifications;
  final List<CertificationModel> availableCertifications;

  AllCertificationsResponse({
    required this.completedCertifications,
    required this.availableCertifications,
  });
}
