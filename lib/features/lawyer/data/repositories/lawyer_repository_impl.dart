import 'package:lawyer_app/features/lawyer/data/datasources/lawyer_remote_datasource.dart';
import 'package:lawyer_app/features/lawyer/domain/repositories/lawyer_repository.dart';

class LawyerRepositoryImpl implements LawyerRepository {
  final LawyerRemoteDataSource remoteDataSource;

  LawyerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> getLawyers(int pageNumber, int pageSize) async {
    return await remoteDataSource.getLawyers(pageNumber, pageSize);
  }
}
