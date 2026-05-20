import 'package:dio/dio.dart' as dio_pkg;
import 'package:lawyer_app/features/client/domain/repositories/client_repository.dart';

class CreateCaseUseCase {
  final ClientRepository repository;

  CreateCaseUseCase(this.repository);

  Future<dynamic> execute(dio_pkg.FormData formData) async {
    return await repository.createCase(formData);
  }
}

class GetCasesByUserIdUseCase {
  final ClientRepository repository;

  GetCasesByUserIdUseCase(this.repository);

  Future<dynamic> execute(int userId) async {
    return await repository.getCasesByUserId(userId);
  }
}
