$ErrorActionPreference = "Stop"

$loginContent = @"
import 'dart:developer';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';
import 'package:lawyer_app/core/utils/storage_service.dart';
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
        final String fullName = data['fullName'] as String;
        final String token = data['token'] as String;

        await StorageService.instance.saveAccessToken(token);

        state = LoginSuccess(
          fullName: fullName,
          token: token,
          message: responseData['message'] ?? 'Login Successful',
        );

        return {'fullName': fullName, 'token': token};
      } else {
        state = LoginFailure(responseData['errorMessage'] ?? 'Login Failed');
        return null;
      }
    } on ApiException catch (e) {
      state = LoginFailure(e.message);
      return null;
    } catch (e, st) {
      log("LoginController error: `$e");
      state = LoginFailure("Network error. Please check your connection.");
      return null;
    }
  }
}
"@
Set-Content -Path "lib/features/auth/presentation/controllers/login_controller.dart" -Value $loginContent -Encoding UTF8

$signupContent = @"
import 'dart:developer';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:lawyer_app/features/auth/presentation/states/signup_state.dart';

class SignupController extends StateNotifier<SignupState> {
  final SignupUseCase _signupUseCase;

  SignupController({SignupUseCase? useCase})
      : _signupUseCase = useCase ?? sl<SignupUseCase>(),
        super(SignupInitial());

  Future<int?> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    state = SignupLoading();
    try {
      final body = {
        "user": {
          "fullName": fullName,
          "email": email,
          "phone": phone,
          "password": password,
          "address": address,
          "profilePhoto": null,
        }
      };

      final responseData = await _signupUseCase.execute(body);

      final Map<String, dynamic> data = responseData['data'] as Map<String, dynamic>;
      final int userId = data['id'] as int;
      final String message = responseData['message'] ?? 'Signup Successful';

      state = SignupSuccess(message);
      return userId;
    } on ApiException catch (e) {
      state = SignupFailure(e.message);
      return null;
    } catch (e) {
      state = SignupFailure("Network error - please try again.");
      return null;
    }
  }
}
"@
Set-Content -Path "lib/features/auth/presentation/controllers/signup_controller.dart" -Value $signupContent -Encoding UTF8

$forgotContent = @"
import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:lawyer_app/features/auth/presentation/states/forgot_password_state.dart';

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordController({ForgotPasswordUseCase? useCase})
      : _forgotPasswordUseCase = useCase ?? sl<ForgotPasswordUseCase>(),
        super(ForgotPasswordInitial());

  Future<void> sendCode(String email) async {
    state = ForgotPasswordLoading();
    try {
      final responseData = await _forgotPasswordUseCase.execute(email);
      final String message = responseData['message'] ?? 'Code sent';
      state = ForgotPasswordSuccess(message);
    } on ApiException catch (e) {
      state = ForgotPasswordFailure(e.message);
    } catch (e) {
      state = ForgotPasswordFailure("Network error. Please try again.");
    }
  }
}
"@
Set-Content -Path "lib/features/auth/presentation/controllers/forgot_password_controller.dart" -Value $forgotContent -Encoding UTF8

$otpContent = @"
import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:lawyer_app/features/auth/presentation/states/otp_state.dart';

class OtpController extends StateNotifier<OtpState> {
  final OtpUseCase _otpUseCase;

  OtpController({OtpUseCase? useCase})
      : _otpUseCase = useCase ?? sl<OtpUseCase>(),
        super(OtpInitial());

  Future<void> verifyOtp(String email, String otp) async {
    state = OtpLoading();
    try {
      final responseData = await _otpUseCase.execute(email, otp);
      final String message = responseData['message'] ?? 'OTP verified';
      state = OtpSuccess(message);
    } on ApiException catch (e) {
      state = OtpFailure(e.message);
    } catch (e) {
      state = OtpFailure("Network error. Please try again.");
    }
  }
}
"@
Set-Content -Path "lib/features/auth/presentation/controllers/otp_controller.dart" -Value $otpContent -Encoding UTF8

$resetContent = @"
import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:lawyer_app/features/auth/presentation/states/reset_password_state.dart';

class ResetPasswordController extends StateNotifier<ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordController({ResetPasswordUseCase? useCase})
      : _resetPasswordUseCase = useCase ?? sl<ResetPasswordUseCase>(),
        super(ResetPasswordInitial());

  Future<void> resetPassword(String email, String newPassword) async {
    state = ResetPasswordLoading();
    try {
      final responseData = await _resetPasswordUseCase.execute(email, newPassword);
      final String message = responseData['message'] ?? 'Password reset successfully';
      state = ResetPasswordSuccess(message);
    } on ApiException catch (e) {
      state = ResetPasswordFailure(e.message);
    } catch (e) {
      state = ResetPasswordFailure("Network error. Please try again.");
    }
  }
}
"@
Set-Content -Path "lib/features/auth/presentation/controllers/reset_password_controller.dart" -Value $resetContent -Encoding UTF8

Write-Host "Auth controllers updated."
