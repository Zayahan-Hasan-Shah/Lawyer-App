import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/student_controller/student_auth_controller/student_signup_controller.dart';
import 'package:lawyer_app/src/states/student_states/student_auth_state/student_signup_state.dart';

final studentSignupProvider =
    StateNotifierProvider<StudentSignupController, StudentSignupState>(
      (ref) => StudentSignupController(),
    );
