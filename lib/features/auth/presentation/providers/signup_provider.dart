import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/auth/presentation/controllers/signup_controller.dart';
import 'package:lawyer_app/features/auth/presentation/states/signup_state.dart';

final signupProvider = StateNotifierProvider<SignupController, SignupState>(
  (ref) => SignupController(),
);

