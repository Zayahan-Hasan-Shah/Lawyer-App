import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:lawyer_app/src/core/constants/api_url.dart';
import 'package:lawyer_app/src/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/src/states/client_states/auth_states/login_state.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController() : super(LoginInitial());

  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    state = LoginLoading();
    try {
      final bodySent = jsonEncode({"email": email, "password": password});
      final response = await http.post(
        Uri.parse(ApiUrl.loginUrl),
        headers: {"Content-Type": "application/json"},
        body: bodySent,
      );

      log("=== LOGIN API ===");
      log("URL : ${ApiUrl.loginUrl}");
      log("STATUS : ${response.statusCode}");
      log("REQ  : $bodySent");
      log("RES  : ${response.body}");
      log("==================");

      // IMPORTANT: Check status code BEFORE trying to decode JSON
      if (response.statusCode == 200) {
        // Only decode if body is not empty
        if (response.body.isEmpty) {
          state = LoginFailure("Empty response from server");
          return null;
        }

        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          final data = responseData['data'] as Map<String, dynamic>;
          final String fullName = data['fullName'] as String;
          final String token = data['token'] as String;

          // Save token to local storage
          await StorageService.instance.saveAccessToken(token);

          state = LoginSuccess(
            fullName: fullName,
            token: token,
            message: responseData['message'] ?? 'Login Successful',
          );

          return {'fullName': fullName, 'token': token};
        } else {
          final String error = responseData['errorMessage'] ?? 'Login Failed';
          state = LoginFailure(error);
          return null;
        }
      } else {
        String errorMessage = 'Login Failed';

        if (response.statusCode == 404) {
          errorMessage = 'Login endpoint not found (404)';
        } else if (response.statusCode == 401) {
          errorMessage = 'Invalid email or password';
        } else if (response.statusCode >= 500) {
          errorMessage = 'Server error. Please try again later.';
        }

        if (response.body.isNotEmpty) {
          try {
            final errorJson = jsonDecode(response.body);
            errorMessage =
                errorJson['errorMessage'] ?? errorJson['error'] ?? errorMessage;
          } catch (_) {
            // If not valid JSON, ignore
          }
        }

        state = LoginFailure(errorMessage);
        return null;
      }
    } catch (e, stackTrace) {
      log("LoginController → Unexpected exception: $e");
      log("LoginController → Stack trace: $stackTrace");
      state = LoginFailure("Network error. Please check your connection.");
      return null;
    }
  }
}
