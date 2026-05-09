import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/student/presentation/controllers/student_auth_controller/student_signup_controller.dart';
import 'package:lawyer_app/features/student/presentation/states/student_auth_state/student_signup_state.dart';

final studentSignupProvider =
    StateNotifierProvider<StudentSignupController, StudentSignupState>(
      (ref) => StudentSignupController(),
    );

