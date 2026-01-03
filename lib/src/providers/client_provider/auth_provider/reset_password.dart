import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/client_controller/auth_controller/reset_password_controller.dart';
import 'package:lawyer_app/src/states/client_states/auth_states/reset_password_state.dart';

final resetPasswordProvider =
    StateNotifierProvider<ResetPasswordController, ResetPasswordState>(
      (ref) => ResetPasswordController(),
    );
