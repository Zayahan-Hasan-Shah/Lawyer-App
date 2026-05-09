import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/student/presentation/controllers/student_auth_controller/student_login_controller.dart';
import 'package:lawyer_app/features/student/presentation/states/student_auth_state/student_login_state.dart';

final studentLoginProvider =
    StateNotifierProvider<StudentLoginController, StudentLoginState>(
      (ref) => StudentLoginController(),
    );

