import 'package:lawyer_app/core/network/api_client.dart';
import 'package:lawyer_app/core/constants/api_url.dart';

abstract class AuthRemoteDataSource {
  Future<dynamic> login(String email, String password);
  Future<dynamic> signup(Map<String, dynamic> body);
  Future<dynamic> forgotPassword(String email);
  Future<dynamic> verifyOtp(String email, String otp);
  Future<dynamic> resetPassword(String email, String newPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<dynamic> login(String email, String password) async {
    return await apiClient.post(ApiUrl.loginUrl, data: {
      "email": email,
      "password": password,
    });
  }

  @override
  Future<dynamic> signup(Map<String, dynamic> body) async {
    return await apiClient.post(ApiUrl.signupUrl, data: body);
  }

  @override
  Future<dynamic> forgotPassword(String email) async {
    return await apiClient.post(ApiUrl.forgotPasswordUrl, data: {
      "email": email,
    });
  }

  @override
  Future<dynamic> verifyOtp(String email, String otp) async {
    return await apiClient.post(ApiUrl.otpUrl, data: {
      "email": email,
      "otp": otp,
    });
  }

  @override
  Future<dynamic> resetPassword(String email, String newPassword) async {
    return await apiClient.post(ApiUrl.resetPasswordUrl, data: {
      "email": email,
      "newPassword": newPassword,
    });
  }
}
