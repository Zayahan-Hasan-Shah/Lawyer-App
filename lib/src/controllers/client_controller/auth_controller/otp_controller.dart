import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/core/constants/api_url.dart';
import 'package:lawyer_app/src/states/client_states/auth_states/otp_state.dart';

class OtpController extends StateNotifier<OtpState> {
  OtpController() : super(OtpStateInitial());

  Future<String> verifyOtp(String otp) async {
    state = OtpStateLoading();
    try {
      final bodySent = jsonEncode({"otp": otp});
      final response = await http.post(
        Uri.parse(ApiUrl.otpUrl),
        headers: {"Content-Type": "application/json"},
        body: bodySent,
      );
      log("=====================================");
      log("*** API URL : ${ApiUrl.otpUrl} ***");
      log("*** STATUS CODE : ${response.statusCode} ***");
      log("*** BODY : ${response.body} ***");
      log("=====================================");

      if (otp == '123456') {
        return "OTP Verified Successfully.";
      } else {
        state = OtpStateFailure("OTP Failed. Invalid OTP.");
        return "OTP Failed. Invalid OTP.";
      }

      // if (response.statusCode == 200) {
      //   final responseData = jsonDecode(response.body);
      //   final message = responseData['message'];
      //   state = OtpStateSuccess(message);
      //   return message;
      // } else {
      //   final responseData = jsonDecode(response.body);
      //   final error = responseData['error'] ?? 'OTP Failed';
      //   state = OtpStateFailure(error);
      //   return error;
      // }
    } catch (e) {
      state = OtpStateFailure("OTP Failed. Invalid OTP.");
      return "Invalid OTP.";
    }
  }
}
