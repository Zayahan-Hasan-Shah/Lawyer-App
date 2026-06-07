import 'package:lawyer_app/features/client/domain/entities/case_entity.dart';
import 'package:lawyer_app/features/lawyer/domain/entities/lawyer_case_entity.dart';

class LawyerCaseModel extends LawyerCaseEntity {
  LawyerCaseModel({
    required super.id,
    required super.caseNo,
    required super.title,
    required super.court,
    required super.status,
    required super.client,
    required super.category,
    required super.appointmentType,
    required super.documents,
    super.hearingDate,
    super.disposedDate,
    super.outcomeSummary,
    super.notes = const [],
    super.advocate,
  });

  factory LawyerCaseModel.fromJson(Map<String, dynamic> json, {List<CaseNoteEntity> notes = const []}) {
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
      notes: notes,
      advocate: json['advocate'] as String?,
    );
  }

  factory LawyerCaseModel.fromEntity(CaseEntity entity) {
    return LawyerCaseModel(
      id: entity.id,
      caseNo: entity.caseNo,
      title: entity.title,
      court: entity.court,
      status: entity.status,
      client: entity.client,
      category: entity.category,
      appointmentType: entity.appointmentType ?? 'Walk-In',
      documents: entity.documents,
      hearingDate: entity.hearingDate,
      disposedDate: entity.disposedDate,
      outcomeSummary: entity.outcome,
      notes: entity.notes,
      advocate: entity.advocate,
    );
  }
}
