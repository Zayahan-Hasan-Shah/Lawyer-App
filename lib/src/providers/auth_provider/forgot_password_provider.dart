import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/auth_controller/forgot_password_controller.dart';
import 'package:lawyer_app/src/states/auth_states/forogot_password_State.dart';

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordController, ForgotPasswordState>(
      (ref) => ForgotPasswordController(),
    );
