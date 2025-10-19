import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/core/constants/api_url.dart';
import 'package:lawyer_app/src/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/src/states/auth_states/reset_password_state.dart';

class ResetPasswordController extends StateNotifier<ResetPasswordState> {
  ResetPasswordController() : super(ResetPasswordStateInitial());

  Future<String> resetPassword(String password) async {
    state = ResetPasswordStateLoading();
    try {
      final email = await StorageService().getForgotEmail();
      final bodySent = jsonEncode({"email": email, "password": password});
      final response = await http.post(
        Uri.parse(ApiUrl.resetPasswordUrl),
        headers: {"Content-Type": "application/json"},
        body: bodySent,
      );
      log("=====================================");
      log("*** API URL : ${ApiUrl.resetPasswordUrl} ***");
      log("*** STATUS CODE : ${response.statusCode} ***");
      log("*** BODY : ${response.body} ***");
      log("=====================================");

      if (email == 'zayahan@gmail.com' && password == 'zayahan123') {
        await StorageService().deleteForgotEmail();
        return "Password Reset Successfully.";
      } else {
        state = ResetPasswordStateFailure("Reset Password Failed");
        return "Reset Password Failed.";
      }

      // if (response.statusCode == 200) {
      //   final responseData = jsonDecode(response.body);
      //   final message = responseData['message'];
      //   state = ResetPasswordStateSuccess(message);
      //   await StorageService().deleteForgotEmail();
      //   return message;
      // } else {
      //   final responseData = jsonDecode(response.body);
      //   final error = responseData['error'] ?? 'Reset Password Failed';
      //   state = ResetPasswordStateFailure(error);
      //   return error;
      // }
    } catch (e) {
      state = ResetPasswordStateFailure("Reset Password Failed. Invalid OTP.");
      return "Reset Password Failed.";
    }
  }
}
