import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/states/student_states/student_auth_state/student_login_state.dart';

class StudentLoginController extends StateNotifier<StudentLoginState> {
  StudentLoginController() : super(StudentLoginInitial());

  Future<Map<String, dynamic>?> studentlLogin({
    required String email,
    required String password,
  }) async {
    state = StudentLoginLoading();
    try {
      if (email == "zayahan@gmail.com" && password == '123qwe') {
        final mockResponse = {
          "fullName": "Zayahan Hasan Shah",
          "token": "abc1234", // ← matches key below
          "message": "Login Successful",
        };

        state = StudentLoginSuccess(
          fullName: mockResponse['fullName']!,
          token: mockResponse['token']!,
          message: mockResponse['message']!,
        );

        return {
          'fullName': mockResponse["fullName"],
          'token': mockResponse["accessToken"],
        };
      }

      state = StudentLoginFailure("Invalid email or password");
      return null;
    } catch (e, stackTrace) {
      log("LoginController → Error: $e");
      log(stackTrace.toString());
      state = StudentLoginFailure("Network error. Please try again.");
      return null;
    }
  }
}
