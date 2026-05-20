import 'package:dio/dio.dart' as dio_pkg;
import 'package:lawyer_app/features/client/data/datasources/client_remote_datasource.dart';
import 'package:lawyer_app/features/client/domain/repositories/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDataSource remoteDataSource;

  ClientRepositoryImpl(this.remoteDataSource);

  @override
  Future<dynamic> createCase(dio_pkg.FormData formData) async {
    return await remoteDataSource.createCase(formData);
  }

  @override
  Future<dynamic> getCasesByUserId(int userId) async {
    return await remoteDataSource.getCasesByUserId(userId);
  }
}
