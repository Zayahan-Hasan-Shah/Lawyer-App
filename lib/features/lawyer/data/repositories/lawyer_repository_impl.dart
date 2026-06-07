import 'package:lawyer_app/features/lawyer/data/datasources/lawyer_remote_datasource.dart';
import 'package:lawyer_app/features/lawyer/data/models/lawyer_model.dart';
import 'package:lawyer_app/features/lawyer/domain/entities/lawyer_entity.dart';
import 'package:lawyer_app/features/lawyer/domain/repositories/lawyer_repository.dart';

class LawyerRepositoryImpl implements LawyerRepository {
  final LawyerRemoteDataSource remoteDataSource;

  LawyerRepositoryImpl(this.remoteDataSource);

  @override
  Future<PaginatedLawyersEntity> getLawyers(int pageNumber, int pageSize) async {
    final data = await remoteDataSource.getLawyers(pageNumber, pageSize);

    final List<dynamic> items = data['data']['items'] as List<dynamic>? ?? [];
    final int totalPages = data['data']['totalPages'] as int? ?? 1;

    final lawyers = items
        .map((e) => LawyerModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return PaginatedLawyersEntity(
      lawyers: lawyers,
      currentPage: pageNumber,
      totalPages: totalPages,
      hasMore: pageNumber < totalPages,
    );
  }
}
