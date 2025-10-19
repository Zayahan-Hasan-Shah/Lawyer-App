import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:lawyer_app/src/core/constants/api_url.dart';
import 'package:lawyer_app/src/states/auth_states/forogot_password_State.dart';

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordController() : super(ForgotPasswordInitial());

  Future<String> forgotPassword({required String email}) async {
    state = ForgotPasswordLoading();
    try {
      final bodySent = jsonEncode({"email": email});
      final response = await http.post(
        Uri.parse(ApiUrl.loginUrl),
        headers: {"Content-Type": "application/json"},
        body: bodySent,
      );
      log("=====================================");
      log("*** API URL : ${ApiUrl.forgotPasswordUrl} ***");
      log("*** STATUS CODE : ${response.statusCode} ***");
      log("*** BODY : ${response.body} ***");
      log("=====================================");

      if (email == 'zayahan@gmail.com') {
        return "OTP sent to your email.";
      } else {
        state = ForgotPasswordFailure("Forgot Password Failed");
        return "Forgot Password Failed";
      }

      // if (response.statusCode == 200) {
      //   final responseData = jsonDecode(response.body);
      //   final message = responseData['message'];
      //   state = ForgotPasswordSuccess(message);
      //   return message;
      // } else {
      //   final responseData = jsonDecode(response.body);
      //   final error = responseData['error'] ?? 'Forgot Password Failed';
      //   state = ForgotPasswordFailure(error);
      //   return error;
      // }
    } catch (e) {
      state = ForgotPasswordFailure(
        "Forgot Password Failed. Please try again.",
      );
      return "Forgot Password Failed. Please try again.";
    }
  }
}
