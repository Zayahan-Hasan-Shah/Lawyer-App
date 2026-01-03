import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/states/lawyer_states/lawyer_auth_state/lawyer_signup_state.dart';

class LawyerSignupController extends StateNotifier<LawyerSignupState> {
  LawyerSignupController() : super(LawyerSignupInitial());

  Future<void> lawyerSignUp({
    required String fullName,
    required String email,
    required String barCouncilNo,
    required String phoneNumber,
    required String yearOfEnrollment,
    required String password,
    required String category,
  }) async {
    state = LawyerSignupInitial();

    // barcouncilno format
    // XXXXX-XXXXXX-X
    try {
      if (fullName == 'Zayahan Hasan Shah' &&
          email == 'zayahan@gmail.com' &&
          barCouncilNo == '12345-678901-2' &&
          (phoneNumber == '923327699137' || phoneNumber == '03327699137') &&
          yearOfEnrollment == '2016' &&
          password == '123qwe' &&
          (category == 'Gold' ||
              category == 'Platinum' ||
              category == 'Silver' ||
              category == 'Bronze' ||
              category == "Green Card")) {
        state = LawyerSignupSuccess("Signup Successfull");
        return;
      }
      state = LawyerSignupFailure("Signup Failed");
    } catch (e, st) {
      log("LawyerSignupController → Exception: $e");
      log("StackTrace: $st");
      state = LawyerSignupFailure("Network error – please try again.");
    }
  }
}
