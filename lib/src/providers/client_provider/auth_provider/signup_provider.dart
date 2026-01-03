import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/client_controller/auth_controller/signup_controller.dart';
import 'package:lawyer_app/src/states/client_states/auth_states/signup_state.dart';

final signupProvider = StateNotifierProvider<SignupController, SignupState>(
  (ref) => SignupController(),
);
