import 'package:lawyer_app/features/client/domain/entities/case_entity.dart';
import 'package:lawyer_app/features/client/domain/repositories/client_repository.dart';

class CreateCaseUseCase {
  final ClientRepository repository;

  CreateCaseUseCase(this.repository);

  Future<CaseEntity> execute(CreateCaseParams params) async {
    return await repository.createCase(params);
  }
}

class GetCasesByUserIdUseCase {
  final ClientRepository repository;

  GetCasesByUserIdUseCase(this.repository);

  Future<List<CaseEntity>> execute(int userId) async {
    return await repository.getCasesByUserId(userId);
  }
}