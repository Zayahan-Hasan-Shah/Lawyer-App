import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/auth_controller/login_controller.dart';
import 'package:lawyer_app/src/states/auth_states/login_state.dart';

final loginProvider = StateNotifierProvider<LoginController, LoginState>(
  (ref) => LoginController(),
);
