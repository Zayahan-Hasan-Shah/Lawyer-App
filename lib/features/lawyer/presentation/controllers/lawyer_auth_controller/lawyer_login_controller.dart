import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/lawyer/presentation/states/lawyer_auth_state/lawyer_login_state.dart';

class LawyerLoginController extends StateNotifier<LawyerLoginState> {
  LawyerLoginController() : super(LawyerLoginInitial());

  Future<Map<String, dynamic>?> lawyerLogin({
    required String email,
    required String password,
  }) async {
    state = LawyerLoginLoading(); // â† Show loading

    try {
      // Mock successful login
      if (email == "zayahan@gmail.com" && password == "123qwe") {
        final mockResponse = {
          "fullName": "Zayahan Hasan Shah",
          "accessToken": "abc1234", // â† matches key below
          "message": "Login Successful",
        };

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

      // Wrong credentials
      state = LawyerLoginFailure("Invalid email or password.");
      return null;
    } catch (e, stackTrace) {
      log("LoginController â†’ Error: $e");
      log(stackTrace.toString());
      state = LawyerLoginFailure("Network error. Please try again.");
      return null;
    }
  }
}

