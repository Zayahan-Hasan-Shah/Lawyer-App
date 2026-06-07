import 'package:lawyer_app/features/lawyer/domain/entities/lawyer_entity.dart';
import 'package:lawyer_app/features/lawyer/domain/repositories/lawyer_repository.dart';

class GetLawyersUseCase {
  final LawyerRepository repository;

  GetLawyersUseCase(this.repository);

  Future<PaginatedLawyersEntity> execute(int pageNumber, int pageSize) async {
    return await repository.getLawyers(pageNumber, pageSize);
  }
}
