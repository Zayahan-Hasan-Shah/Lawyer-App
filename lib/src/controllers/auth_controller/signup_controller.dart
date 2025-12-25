// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter_riverpod/legacy.dart';
// import 'package:lawyer_app/src/core/constants/api_url.dart';
// import 'package:lawyer_app/src/states/auth_states/signup_state.dart';
// import 'package:http/http.dart' as http;

// class SignupController extends StateNotifier<SignupState> {
//   SignupController() : super(SignupInitial());
//   Future<String?> signup({
//     required String name,
//     required String email,
//     required String phoneNumber,
//     required String password,
//     required String address,
//   }) async {
//     state = SignupLoading();
//     try {
//       final bodySent = jsonEncode({
//         "name": name,
//         "email": email,
//         "phone_number": phoneNumber,
//         "password": password,
//         "address": address,
//       });
//       final response = await http.post(
//         Uri.parse(ApiUrl.signupUrl),
//         headers: {"Content-Type": "application/json"},
//         body: bodySent,
//       );
//       log("=====================================");
//       log("*** API URL : ${ApiUrl.signupUrl} ***");
//       log("*** STATUS CODE : ${response.statusCode} ***");
//       log("*** BODY : ${response.body} ***");
//       log("=====================================");

//       // if (name == "zayahan" &&
//       //     email == "zayaha@gmail.com" &&
//       //     phoneNumber == "03327699137" &&
//       //     password == "zayahan123" &&
//       //     address == "karachi") {
//       //   return "Signup Successful";
//       // } else {
//       //   state = SignupFailure("Signup Failed");
//       //   return null;
//       // }

//       if (response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         final message = responseData['message'] ?? 'Signup Successful';
//         state = SignupSuccess(message);
//         return message;
//       } else {
//         final responseData = jsonDecode(response.body);
//         final error = responseData['error'] ?? 'Signup Failed';
//         state = SignupFailure(error);
//         return error;
//       }
//     } catch (e, stackTrace) {
//       log("LoginController → Unexpected exception: $e");
//       log("LoginController → Stack trace: $stackTrace");
//       state = SignupFailure("An unexpected error occurred. Please try again.");
//       return null;
//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/core/constants/api_url.dart';
import 'package:lawyer_app/src/states/auth_states/signup_state.dart';
import 'package:http/http.dart' as http;

class SignupController extends StateNotifier<SignupState> {
  SignupController() : super(SignupInitial());

  /// Returns the **created user id** on success, `null` on failure.
  Future<int?> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String address,
    // profilePhoto is optional – not sent for now
  }) async {
    state = SignupLoading();
    try {
      // ----> MATCH THE BACKEND JSON KEYS <----
      final bodySent = jsonEncode({
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "password": password,
        "address": address,
        "profilePhoto": '', // omitted – optional
        "isActive": false, // omitted – backend default
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

      if (response.statusCode == 201) {
        // Backend returns the newly created user object
        final int userId = json['user']['id'] as int;
        final String message = json['message'] ?? 'Signup Successful';
        state = SignupSuccess(message);
        return userId;
      } else {
        final String error = json['error'] ?? 'Signup Failed';
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
