import 'package:lawyer_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:lawyer_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<dynamic> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<dynamic> signup(Map<String, dynamic> body) async {
    return await remoteDataSource.signup(body);
  }

  @override
  Future<dynamic> forgotPassword(String email) async {
    return await remoteDataSource.forgotPassword(email);
  }

  @override
  Future<dynamic> verifyOtp(String email, String otp) async {
    return await remoteDataSource.verifyOtp(email, otp);
  }

  @override
  Future<dynamic> resetPassword(String email, String newPassword) async {
    return await remoteDataSource.resetPassword(email, newPassword);
  }
}
