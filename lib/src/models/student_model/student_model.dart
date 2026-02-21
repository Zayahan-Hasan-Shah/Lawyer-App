class StudentModel {
  final String id;
  final String fullName;
  final String university;
  final String studyYear;
  final String currentProgram;
  final String email;
  final String profileImage;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.university,
    required this.studyYear,
    required this.currentProgram,
    required this.email,
    required this.profileImage,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      university: json['university'] ?? '',
      studyYear: json['studyYear'] ?? '',
      currentProgram: json['currentProgram'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'university': university,
      'studyYear': studyYear,
      'currentProgram': currentProgram,
      'email': email,
      'profileImage': profileImage,
    };
  }
}
