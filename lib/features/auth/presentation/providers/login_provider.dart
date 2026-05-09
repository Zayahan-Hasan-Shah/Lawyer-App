import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:lawyer_app/features/auth/presentation/states/login_state.dart';

final loginProvider = StateNotifierProvider<LoginController, LoginState>(
  (ref) => LoginController(),
);

