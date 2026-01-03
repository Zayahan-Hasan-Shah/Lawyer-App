import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/lawyer_controller/lawyer_auth_controller/lawyer_login_controller.dart';
import 'package:lawyer_app/src/states/lawyer_states/lawyer_auth_state/lawyer_login_state.dart';

final lawyerLoginProvider =
    StateNotifierProvider<LawyerLoginController, LawyerLoginState>(
      (ref) => LawyerLoginController(),
    );
