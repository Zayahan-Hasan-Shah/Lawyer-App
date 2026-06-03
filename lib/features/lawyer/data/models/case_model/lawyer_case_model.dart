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
      id: json['id'] as int? ?? 0,
      caseNo: json['caseId'] as String? ?? json['caseNo'] as String? ?? json['caseNumber'] as String? ?? 'N/A',
      title: json['title'] as String? ?? "${json['caseType'] ?? 'General'} Case",
      court: json['court'] as String? ?? 'Delhi High Court',
      status: json['status'] as String? ?? 'Pending',
      client: json['client'] as String? ?? json['createdBy'] as String? ?? 'Client',
      category: json['category'] as String? ?? json['caseType'] as String? ?? 'General',
      appointmentType: json['appointment_Type'] as String? ?? json['appointmentType'] as String? ?? 'Walk-In',
      documents: json['documents'] != null
          ? (json['documents'] as List<dynamic>).map((e) => e.toString()).toList()
          : (json['file_Path'] != null ? [json['file_Path'] as String] : const <String>[]),
      hearingDate: json['hearingDate'] as String? ?? json['appointmentDate'] as String?,
      disposedDate: json['disposedDate'] as String?,
      outcomeSummary: json['outcomeSummary'] as String? ?? json['outcome'] as String?,
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
