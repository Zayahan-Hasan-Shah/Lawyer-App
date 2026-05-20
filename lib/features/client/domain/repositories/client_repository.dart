import 'package:dio/dio.dart' as dio_pkg;

abstract class ClientRepository {
  Future<dynamic> createCase(dio_pkg.FormData formData);
  Future<dynamic> getCasesByUserId(int userId);
}
