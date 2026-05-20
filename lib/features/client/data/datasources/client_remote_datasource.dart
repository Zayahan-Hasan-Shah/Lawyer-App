import 'package:dio/dio.dart' as dio_pkg;
import 'package:lawyer_app/core/network/api_client.dart';

abstract class ClientRemoteDataSource {
  Future<dynamic> createCase(dio_pkg.FormData formData);
  Future<dynamic> getCasesByUserId(int userId);
}

class ClientRemoteDataSourceImpl implements ClientRemoteDataSource {
  final ApiClient apiClient;

  ClientRemoteDataSourceImpl(this.apiClient);

  @override
  Future<dynamic> createCase(dio_pkg.FormData formData) async {
    return await apiClient.post('/CaseInfos', data: formData);
  }

  @override
  Future<dynamic> getCasesByUserId(int userId) async {
    return await apiClient.get('/CaseInfos/by-user/$userId');
  }
}
