import 'package:lawyer_app/core/network/api_client.dart';
import 'package:lawyer_app/core/constants/api_url.dart';

abstract class LawyerRemoteDataSource {
  Future<Map<String, dynamic>> getLawyers(int pageNumber, int pageSize);
}

class LawyerRemoteDataSourceImpl implements LawyerRemoteDataSource {
  final ApiClient apiClient;

  LawyerRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> getLawyers(int pageNumber, int pageSize) async {
    final response = await apiClient.get(
      ApiUrl.getAllLayersUrl,
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return response as Map<String, dynamic>;
  }
}
