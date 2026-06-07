// models/case_model.dart

class CaseNote {
  final int id;
  final String caseId;
  final DateTime date;
  final String notes;
  final String? createdBy;
  final String? createdOn;
  final String? updatedBy;
  final String? updatedOn;

  CaseNote({
    required this.id,
    required this.caseId,
    required this.date,
    required this.notes,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
  });

  factory CaseNote.fromJson(Map<String, dynamic> json) {
    return CaseNote(
      id: json['id'] as int? ?? 0,
      caseId: json['caseId']?.toString() ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      notes:
          json['notes'] as String? ??
          json['content'] as String? ??
          json['note'] as String? ??
          '',
      createdBy: json['createdBy'] as String?,
      createdOn: json['createdOn'] as String?,
      updatedBy: json['updatedBy'] as String?,
      updatedOn: json['updatedOn'] as String?,
    );
  }
}

class CaseModel {
  final int id;
  final String caseNo;
  final String title;
  final String court;
  final String status;
  final String? hearingDate; // pending only
  final String? nextHearing;
  final String? disposedDate; // disposed only
  final String? outcome; // disposed only
  final String client;
  final String category;
  final String? lawyerId;
  final String? lawyerName;
  final String? submissionMethod;
  final String? appointmentType;
  final String? advocate;
  final List<CaseNote> notes;

  CaseModel({
    required this.id,
    required this.caseNo,
    required this.title,
    required this.court,
    required this.status,
    this.hearingDate,
    this.nextHearing,
    this.disposedDate,
    this.outcome,
    required this.client,
    required this.category,
    this.lawyerId,
    this.lawyerName,
    this.submissionMethod,
    this.appointmentType,
    this.notes = const [],
    this.advocate,
  });

  factory CaseModel.fromJson(
    Map<String, dynamic> json, {
    List<CaseNote> notes = const [],
  }) {
    return CaseModel(
      id: json['id'] as int? ?? 0,
      caseNo:
          json['caseId'] as String? ??
          json['caseNo'] as String? ??
          json['caseNumber'] as String? ??
          '',
      title:
          json['title'] as String? ?? "${json['caseType'] ?? 'General'} Case",
      court: json['court'] as String? ?? 'TBD',
      status: json['status'] as String? ?? 'Pending',
      hearingDate:
          json['hearingDate'] as String? ?? json['appointmentDate'] as String?,
      nextHearing: json['nextHearing'] as String?,
      disposedDate: json['disposedDate'] as String?,
      outcome: json['outcome'] as String?,
      client:
          json['client'] as String? ?? json['createdBy'] as String? ?? 'Client',
      category:
          json['category'] as String? ??
          json['caseType'] as String? ??
          'General',
      lawyerId: json['lawyerId']?.toString(),
      lawyerName:
          json['lawyerName'] as String? ??
          json['advocate'] as String? ??
          'Not Assigned',
      submissionMethod: json['submissionMethod'] as String?,
      appointmentType:
          json['appointment_Type'] as String? ??
          json['appointmentType'] as String?,
      notes: notes,
      advocate: json['advocate'] as String?,
    );
  }
}

class AllCasesResponse {
  final List<CaseModel> pendingCases;
  final List<CaseModel> disposedCases;

  AllCasesResponse({required this.pendingCases, required this.disposedCases});
}
