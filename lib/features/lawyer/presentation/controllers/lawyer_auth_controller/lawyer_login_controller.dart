import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';
import 'package:lawyer_app/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:lawyer_app/features/lawyer/presentation/states/lawyer_auth_state/lawyer_login_state.dart';

class LawyerLoginController extends StateNotifier<LawyerLoginState> {
  final LoginUseCase _loginUseCase;

  LawyerLoginController({LoginUseCase? loginUseCase})
      : _loginUseCase = loginUseCase ?? sl<LoginUseCase>(),
        super(LawyerLoginInitial());

  Future<Map<String, dynamic>?> lawyerLogin({
    required String email,
    required String password,
  }) async {
    state = LawyerLoginLoading(); // ← Show loading

    try {
      // Mock successful login bypass:
      if (email == "zayahan@gmail.com" && password == "123qwe") {
        final mockResponse = {
          "fullName": "Zayahan Hasan Shah",
          "accessToken": "abc1234",
          "message": "Login Successful",
        };

        await StorageService.instance.saveAccessToken("abc1234");
        await StorageService.instance.saveUserId(24);
        await StorageService.instance.saveUserType("Lawyer");
        await StorageService.instance.saveFullName("Zayahan Hasan Shah");

        state = LawyerLoginSuccess(
          fullName: mockResponse["fullName"]!,
          token: mockResponse["accessToken"]!,
          message: mockResponse["message"]!,
        );

        return {
          'fullName': mockResponse["fullName"],
          'token': mockResponse["accessToken"],
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

        await StorageService.instance.saveAccessToken(token);
        await StorageService.instance.saveUserId(userId);
        await StorageService.instance.saveUserType(userType);
        await StorageService.instance.saveFullName(fullName);
        await StorageService.instance.saveExpiresUtc(expiresUtc);
        await StorageService.instance.saveExpiresLocal(expiresLocal);

        state = LawyerLoginSuccess(
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
        state = LawyerLoginFailure(responseData['errorMessage'] ?? 'Login Failed');
        return null;
      }
    } on ApiException catch (e) {
      state = LawyerLoginFailure(e.message);
      return null;
    } catch (e, stackTrace) {
      log("LoginController → Error: $e");
      log(stackTrace.toString());
      state = const LawyerLoginFailure("Network error. Please try again.");
      return null;
    }
  }
}
