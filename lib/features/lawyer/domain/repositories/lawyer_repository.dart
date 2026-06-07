import 'package:lawyer_app/features/lawyer/domain/entities/lawyer_entity.dart';

abstract class LawyerRepository {
  Future<PaginatedLawyersEntity> getLawyers(int pageNumber, int pageSize);
}
