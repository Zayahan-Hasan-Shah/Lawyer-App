import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/constants/app_keys.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';
import 'package:lawyer_app/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:lawyer_app/features/student/presentation/states/student_auth_state/student_login_state.dart';

class StudentLoginController extends StateNotifier<StudentLoginState> {
  final LoginUseCase _loginUseCase;

  StudentLoginController({LoginUseCase? loginUseCase})
      : _loginUseCase = loginUseCase ?? sl<LoginUseCase>(),
        super(StudentLoginInitial());

  Future<Map<String, dynamic>?> studentlLogin({
    required String email,
    required String password,
  }) async {
    state = StudentLoginLoading();
    try {
      // Mock bypass for zayahan
      if (email == "zayahan@gmail.com" && password == '123qwe') {
        final mockResponse = {
          "fullName": "Zayahan Hasan Shah",
          "token": "abc1234",
          "message": "Login Successful",
        };

        await StorageService.instance.write(AppKeys.accessTokenKey, "abc1234");
        await StorageService.instance.write(AppKeys.userIdKey, "25");
        await StorageService.instance.write(AppKeys.userTypeKey, "Student");
        await StorageService.instance.write(AppKeys.fullNameKey, "Zayahan Hasan Shah");

        state = StudentLoginSuccess(
          fullName: mockResponse['fullName']!,
          token: mockResponse['token']!,
          message: mockResponse['message']!,
        );

        return {
          'fullName': mockResponse["fullName"],
          'token': mockResponse["token"],
        };
      }

      final responseData = await _loginUseCase.execute(email, password);

      if (responseData['status'] == 'success') {
        final data = responseData['data'] as Map<String, dynamic>;
        final int userId = data['userId'] as int;
        final String? userType = data['userType'] as String?;
        final String fullName = data['fullName'] as String;
        final String token = data['token'] as String;
        final String expiresUtc = data['expiresUtc'] as String;
        final String expiresLocal = data['expiresLocal'] as String;

        // Perform userType comparison
        if (userType == null || userType.toLowerCase() != 'student') {
          state = StudentLoginFailure("Account type does not match this login portal");
          return null;
        }

        await StorageService.instance.write(AppKeys.accessTokenKey, token);
        await StorageService.instance.write(AppKeys.userIdKey, userId.toString());
        await StorageService.instance.write(AppKeys.userTypeKey, userType);
        await StorageService.instance.write(AppKeys.fullNameKey, fullName);
        await StorageService.instance.write(AppKeys.expiresUtcKey, expiresUtc);
        await StorageService.instance.write(AppKeys.expiresLocalKey, expiresLocal);

        state = StudentLoginSuccess(
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
        state = StudentLoginFailure(responseData['errorMessage'] ?? 'Login Failed');
        return null;
      }
    } on ApiException catch (e) {
      state = StudentLoginFailure(e.message);
      return null;
    } catch (e, stackTrace) {
      log("LoginController → Error: $e");
      log(stackTrace.toString());
      state = StudentLoginFailure("Network error. Please try again.");
      return null;
    }
  }
}
