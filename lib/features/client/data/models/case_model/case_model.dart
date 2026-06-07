// models/case_model.dart

import 'package:lawyer_app/features/client/domain/entities/case_entity.dart';

class CaseNoteModel extends CaseNoteEntity {
  CaseNoteModel({
    required super.id,
    required super.caseId,
    required super.date,
    required super.notes,
    super.createdBy,
    super.createdOn,
    super.updatedBy,
    super.updatedOn,
  });

  factory CaseNoteModel.fromJson(Map<String, dynamic> json) {
    return CaseNoteModel(
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

class CaseModel extends CaseEntity {
  CaseModel({
    required super.id,
    required super.caseNo,
    required super.title,
    required super.court,
    required super.status,
    super.hearingDate,
    super.nextHearing,
    super.disposedDate,
    super.outcome,
    required super.client,
    required super.category,
    super.lawyerId,
    super.lawyerName,
    super.submissionMethod,
    super.appointmentType,
    super.notes,
    super.advocate,
    super.documents,
  });

  factory CaseModel.fromJson(
    Map<String, dynamic> json, {
    List<CaseNoteEntity> notes = const [],
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
      documents: json['documents'] != null
          ? (json['documents'] as List<dynamic>).map((e) => e.toString()).toList()
          : (json['file_Path'] != null ? [json['file_Path'] as String] : const <String>[]),
    );
  }
}
