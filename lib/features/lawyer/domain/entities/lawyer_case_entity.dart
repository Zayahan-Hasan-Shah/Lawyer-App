import 'package:lawyer_app/features/client/domain/entities/case_entity.dart';

class LawyerCaseEntity {
  final int id;
  final String caseNo;
  final String title;
  final String court;
  final String status;
  final String client;
  final String category;
  final String appointmentType;
  final List<String> documents;
  final String? hearingDate;
  final String? disposedDate;
  final String? outcomeSummary;
  final List<CaseNoteEntity> notes;
  final String? advocate;

  LawyerCaseEntity({
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
    this.notes = const [],
    this.advocate,
  });
}

class AllLawyerCasesResponse {
  final List<LawyerCaseEntity> pendingCases;
  final List<LawyerCaseEntity> disposedCases;

  AllLawyerCasesResponse({
    required this.pendingCases,
    required this.disposedCases,
  });
}
