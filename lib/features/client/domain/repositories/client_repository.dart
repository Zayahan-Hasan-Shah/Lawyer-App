import 'package:lawyer_app/features/client/domain/entities/case_entity.dart';

class CreateCaseParams {
  final String caseType;
  final String appointmentType;
  final String appointmentDate;
  final String? createdBy;
  final int? userId;
  final String submissionMethod;
  final String? filePath;

  CreateCaseParams({
    required this.caseType,
    required this.appointmentType,
    required this.appointmentDate,
    this.createdBy,
    this.userId,
    required this.submissionMethod,
    this.filePath,
  });
}

abstract class ClientRepository {
  Future<CaseEntity> createCase(CreateCaseParams params);
  Future<List<CaseEntity>> getCasesByUserId(int userId);
}