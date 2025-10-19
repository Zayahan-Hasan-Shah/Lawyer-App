import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:lawyer_app/src/core/constants/api_url.dart';
import 'package:lawyer_app/src/models/user_model/user_model.dart';
import 'package:lawyer_app/src/states/auth_states/login_state.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController() : super(LoginInitial());

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    state = LoginLoading();
    try {
      // final bodySent = jsonEncode({"email": email, "password": password});
      // final response = await http.post(
      //   Uri.parse(ApiUrl.loginUrl),
      //   headers: {"Content-Type": "application/json"},
      //   body: bodySent,
      // );
      // log("=====================================");
      // log("*** API URL : ${ApiUrl.loginUrl} ***");
      // log("*** STATUS CODE : ${response.statusCode} ***");
      // log("*** BODY : ${response.body} ***");
      // log("=====================================");

      if (email == 'zayahan@gmail.com' && password == 'zayahan123') {
        final user = UserModel(
          accessToken: 'accesstoken123',
          userName: "zayahan",
          email: 'zayahan@gmail.com',
          phoneNumber: '03327699137',
          address: 'karachi',
        );
        state = LoginSuccess(user);
        // log("=====================================");
        // log("*** API URL : ${ApiUrl.loginUrl} ***");
        // log("*** STATUS CODE : ${response.statusCode} ***");
        // log("*** BODY : ${response.body} ***");
        // log("*** RESPONSE : $user ***");
        // log("=====================================");
        return user;
      } else {
        state = LoginFailure("Login Failed");
        return null;
      }

      // if (response.statusCode == 200) {
      //   final responseData = jsonDecode(response.body);
      //   final userData = responseData['user'];
      //   final user = UserModel.fromJson(userData);
      //   state = LoginSuccess(user);
      //   return user;
      // } else {
      //   final responseData = jsonDecode(response.body);
      //   final error = responseData['error'] ?? 'Login Failed';
      //   state = LoginFailure(error);
      //   return null;
      // }
    } catch (e, stackTrace) {
      log("LoginController → Unexpected exception: $e");
      log("LoginController → Stack trace: $stackTrace");
      state = LoginFailure("Login Failed. Please try again.");
      return null;
    }
  }
}
