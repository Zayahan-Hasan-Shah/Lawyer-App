import 'dart:developer';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/constants/app_keys.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';
import 'package:lawyer_app/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:lawyer_app/features/auth/presentation/states/login_state.dart';

class LoginController extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginController({LoginUseCase? useCase})
      : _loginUseCase = useCase ?? sl<LoginUseCase>(),
        super(LoginInitial());

  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    state = LoginLoading();
    try {
      final responseData = await _loginUseCase.execute(email, password);

      if (responseData['status'] == 'success') {
        final data = responseData['data'] as Map<String, dynamic>;
        final int userId = data['userId'] as int;
        final String? userType = data['userType'] as String?;
        final String fullName = data['fullName'] as String;
        final String token = data['token'] as String;
        final String expiresUtc = data['expiresUtc'] as String;
        final String expiresLocal = data['expiresLocal'] as String;

        await StorageService.instance.write(AppKeys.accessTokenKey, token);
        await StorageService.instance.write(AppKeys.userIdKey, userId.toString());
        await StorageService.instance.write(AppKeys.userTypeKey, userType ?? '');
        await StorageService.instance.write(AppKeys.fullNameKey, fullName);
        await StorageService.instance.write(AppKeys.expiresUtcKey, expiresUtc);
        await StorageService.instance.write(AppKeys.expiresLocalKey, expiresLocal);

        state = LoginSuccess(
          fullName: fullName,
          token: token,
          message: responseData['message'] ?? 'Login Successful',
        );

        return {
          'userId': userId,
          'userType': userType,
          'fullName': fullName,
          'token': token,
          'expiresUtc': expiresUtc,
          'expiresLocal': expiresLocal,
        };
      } else {
        state = LoginFailure(responseData['errorMessage'] ?? 'Login Failed');
        return null;
      }
    } on ApiException catch (e) {
      state = LoginFailure(e.message);
      return null;
    } catch (e, st) {
      log("LoginController error: $e");
      log("LoginController ST: $st");
      state = LoginFailure("Network error. Please check your connection.");
      return null;
    }
  }
}
