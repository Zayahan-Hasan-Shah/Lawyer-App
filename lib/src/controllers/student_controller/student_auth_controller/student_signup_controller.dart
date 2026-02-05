import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/states/student_states/student_auth_state/student_signup_state.dart';

class StudentSignupController extends StateNotifier<StudentSignupState> {
  StudentSignupController() : super(StudentSignupInitial());

  Future<void> studentSignupCont({
    required String fullName,
    required String fatherName,
    required String dob,
    required String phoneNumber,
    required String university,
    required String address,
    required String password,
    required String email,
  }) async {
    state = StudentSignupLoading();
    try {
      if (fullName == 'Zayahan Hasan Shah' &&
          fatherName == 'Shahid Hussain' &&
          dob == '18-01-2002' &&
          email == 'zayahan@gmail.com' &&
          (phoneNumber == '923327699137' || phoneNumber == '03327699137') &&
          password == '123qwe' &&
          university == "Uok" &&
          address == "Karachi") {
        state = StudentSignupSuccess("Signup Successfull");
        return;
      } else {
        state = StudentSignupFailure("Signup Failed");
      }
    } catch (e) {
      state = StudentSignupFailure("Signup Failed");
    }
  }
}
