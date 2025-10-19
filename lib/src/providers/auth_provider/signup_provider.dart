import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/auth_controller/signup_controller.dart';
import 'package:lawyer_app/src/states/auth_states/signup_state.dart';

final signupProvider = StateNotifierProvider<SignupController, SignupState>(
  (ref) => SignupController(),
);
