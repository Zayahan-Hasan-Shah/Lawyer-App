// models/case_model.dart

class CaseModel {
  final int id;
  final String caseNo;
  final String title;
  final String court;
  final String status;
  final String? hearingDate; // pending only
  final String? disposedDate; // disposed only
  final String? outcome; // disposed only
  final String client;
  final String category;

  CaseModel({
    required this.id,
    required this.caseNo,
    required this.title,
    required this.court,
    required this.status,
    this.hearingDate,
    this.disposedDate,
    this.outcome,
    required this.client,
    required this.category,
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'] as int,
      caseNo: json['caseNo'] as String,
      title: json['title'] as String,
      court: json['court'] as String,
      status: json['status'] as String,
      hearingDate: json['hearingDate'] as String?,
      disposedDate: json['disposedDate'] as String?,
      outcome: json['outcome'] as String?,
      client: json['client'] as String,
      category: json['category'] as String,
    );
  }
}

class AllCasesResponse {
  final List<CaseModel> pendingCases;
  final List<CaseModel> disposedCases;

  AllCasesResponse({required this.pendingCases, required this.disposedCases});
}
