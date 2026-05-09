class LawyerCaseModel {
  final int id;
  final String caseNo;
  final String title;
  final String court;
  final String status;
  final String client;
  final String category;
  final String appointmentType; // Walk-in or Video
  final List<String> documents; // In-app documents list
  final String? hearingDate; // pending only
  final String? disposedDate; // disposed only
  final String? outcomeSummary; // disposed only, lawyer POV

  LawyerCaseModel({
    required this.id,
    required this.caseNo,
    required this.title,
    required this.court,
    required this.status,
    required this.client,
    required this.category,
    required this.appointmentType,
    required this.documents,
    this.hearingDate,
    this.disposedDate,
    this.outcomeSummary,
  });

  factory LawyerCaseModel.fromJson(Map<String, dynamic> json) {
    return LawyerCaseModel(
      id: json['id'] as int,
      caseNo: json['caseNo'] as String,
      title: json['title'] as String,
      court: json['court'] as String,
      status: json['status'] as String,
      client: json['client'] as String,
      category: json['category'] as String,
      appointmentType: json['appointmentType'] as String,
      documents: (json['documents'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      hearingDate: json['hearingDate'] as String?,
      disposedDate: json['disposedDate'] as String?,
      outcomeSummary: json['outcomeSummary'] as String?,
    );
  }
}

class AllLawyerCasesResponse {
  final List<LawyerCaseModel> pendingCases;
  final List<LawyerCaseModel> disposedCases;

  AllLawyerCasesResponse({
    required this.pendingCases,
    required this.disposedCases,
  });
}
