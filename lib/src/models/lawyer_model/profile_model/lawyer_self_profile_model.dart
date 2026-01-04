class LawyerSelfProfileModel {
  final String fullName;
  final String title;
  final String location;
  final int yearsOfPractice;
  final int casesHandled;
  final double overallWinRate; // 0.0 - 1.0
  final int activeMatters;
  final List<String> practiceAreas;
  final String about;
  final String email;
  final String phone;
  final String officeHours;
  final String profileImage;

  LawyerSelfProfileModel({
    required this.fullName,
    required this.title,
    required this.location,
    required this.yearsOfPractice,
    required this.casesHandled,
    required this.overallWinRate,
    required this.activeMatters,
    required this.practiceAreas,
    required this.about,
    required this.email,
    required this.phone,
    required this.officeHours,
    required this.profileImage,
  });
}
