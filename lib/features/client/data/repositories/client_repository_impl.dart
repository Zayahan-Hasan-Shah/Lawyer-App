import 'package:dio/dio.dart' as dio_pkg;
import 'package:lawyer_app/features/client/data/datasources/client_remote_datasource.dart';
import 'package:lawyer_app/features/client/data/models/case_model/case_model.dart';
import 'package:lawyer_app/features/client/domain/entities/case_entity.dart';
import 'package:lawyer_app/features/client/domain/repositories/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDataSource remoteDataSource;

  ClientRepositoryImpl(this.remoteDataSource);

  @override
  Future<CaseEntity> createCase(CreateCaseParams params) async {
    final Map<String, dynamic> map = {
      'caseType': params.caseType,
      'appointment_Type': params.appointmentType,
      'appointmentDate': params.appointmentDate,
      'submissionMethod': params.submissionMethod,
    };

    if (params.createdBy != null) {
      map['createdBy'] = params.createdBy;
    }
    if (params.userId != null) {
      map['userId'] = params.userId;
    }

    if (params.filePath != null && params.filePath!.isNotEmpty) {
      map['file'] = await dio_pkg.MultipartFile.fromFile(params.filePath!);
    }

    final formData = dio_pkg.FormData.fromMap(map);

    final response = await remoteDataSource.createCase(formData);
    final dataMap = response['data'] as Map<String, dynamic>;
    return CaseModel.fromJson(dataMap);
  }

  @override
  Future<List<CaseEntity>> getCasesByUserId(int userId) async {
    final response = await remoteDataSource.getCasesByUserId(userId);
    final dataMap = response['data'] as Map<String, dynamic>;
    final List<dynamic> casesList = dataMap['items'] as List<dynamic>;

    return casesList.map((item) {
      final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
      final Map<String, dynamic> map = (itemMap['caseInfo'] ?? itemMap) as Map<String, dynamic>;
      final List<dynamic> rawNotes = itemMap['notes'] as List<dynamic>? ?? [];
      final notes = rawNotes
          .map((n) => CaseNoteModel.fromJson(n as Map<String, dynamic>))
          .toList();
      return CaseModel.fromJson(map, notes: notes);
    }).toList();
  }
}
