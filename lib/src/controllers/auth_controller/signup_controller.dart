import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/core/constants/api_url.dart';
import 'package:lawyer_app/src/states/auth_states/signup_state.dart';
import 'package:http/http.dart' as http;

class SignupController extends StateNotifier<SignupState> {
  SignupController() : super(SignupInitial());

  Future<int?> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    state = SignupLoading();
    try {
      final bodySent = jsonEncode({
        "user": {
          "fullName": fullName,
          "email": email,
          "phone": phone,
          "password": password,
          "address": address,
          "profilePhoto": null,
        },
      });

      final response = await http.post(
        Uri.parse(ApiUrl.signupUrl),
        headers: {"Content-Type": "application/json"},
        body: bodySent,
      );

      log("=== SIGNUP API ===");
      log("URL : ${ApiUrl.signupUrl}");
      log("STATUS : ${response.statusCode}");
      log("REQ  : $bodySent");
      log("RES  : ${response.body}");
      log("==================");

      final Map<String, dynamic> json = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // The user object is inside "data"
        final Map<String, dynamic> data = json['data'] as Map<String, dynamic>;
        final int userId = data['id'] as int;

        // Optional: use a message if backend provides one, otherwise fallback
        final String message = json['message'] ?? 'Signup Successful';

        state = SignupSuccess(message);
        return userId;
      } else {
        // Handle non-success status codes
        final String error =
            json['errorMessage'] ?? json['error'] ?? 'Signup Failed';
        state = SignupFailure(error);
        return null;
      }
    } catch (e, st) {
      log("SignupController → Exception: $e");
      log("StackTrace: $st");
      state = SignupFailure("Network error – please try again.");
      return null;
    }
  }
}
