import 'package:lawyer_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<dynamic> execute(String email, String password) async {
    return await repository.login(email, password);
  }
}

class SignupUseCase {
  final AuthRepository repository;
  SignupUseCase(this.repository);

  Future<dynamic> execute(Map<String, dynamic> body) async {
    return await repository.signup(body);
  }
}

class ForgotPasswordUseCase {
  final AuthRepository repository;
  ForgotPasswordUseCase(this.repository);

  Future<dynamic> execute(String email) async {
    return await repository.forgotPassword(email);
  }
}

class OtpUseCase {
  final AuthRepository repository;
  OtpUseCase(this.repository);

  Future<dynamic> execute(String email, String otp) async {
    return await repository.verifyOtp(email, otp);
  }
}

class ResetPasswordUseCase {
  final AuthRepository repository;
  ResetPasswordUseCase(this.repository);

  Future<dynamic> execute(String email, String newPassword) async {
    return await repository.resetPassword(email, newPassword);
  }
}
