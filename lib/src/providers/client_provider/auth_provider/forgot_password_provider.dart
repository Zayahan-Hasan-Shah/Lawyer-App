import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/client_controller/auth_controller/forgot_password_controller.dart';
import 'package:lawyer_app/src/states/client_states/auth_states/forogot_password_State.dart';

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordController, ForgotPasswordState>(
      (ref) => ForgotPasswordController(),
    );
