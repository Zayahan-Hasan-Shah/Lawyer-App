abstract class AuthRepository {
  Future<dynamic> login(String email, String password);
  Future<dynamic> signup(Map<String, dynamic> body);
  Future<dynamic> forgotPassword(String email);
  Future<dynamic> verifyOtp(String email, String otp);
  Future<dynamic> resetPassword(String email, String newPassword);
}
