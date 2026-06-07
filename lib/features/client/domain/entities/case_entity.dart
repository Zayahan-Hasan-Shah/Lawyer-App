class CaseNoteEntity {
  final int id;
  final String caseId;
  final DateTime date;
  final String notes;
  final String? createdBy;
  final String? createdOn;
  final String? updatedBy;
  final String? updatedOn;

  CaseNoteEntity({
    required this.id,
    required this.caseId,
    required this.date,
    required this.notes,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
  });
}

class CaseEntity {
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
  final List<CaseNoteEntity> notes;
  final List<String> documents;

  CaseEntity({
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
    this.documents = const [],
  });
}

class AllCasesResponse {
  final List<CaseEntity> pendingCases;
  final List<CaseEntity> disposedCases;

  AllCasesResponse({required this.pendingCases, required this.disposedCases});
}