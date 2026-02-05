import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/student_controller/student_auth_controller/student_login_controller.dart';
import 'package:lawyer_app/src/states/student_states/student_auth_state/student_login_state.dart';

final studentLoginProvider =
    StateNotifierProvider<StudentLoginController, StudentLoginState>(
      (ref) => StudentLoginController(),
    );
