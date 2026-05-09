import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/lawyer/presentation/controllers/lawyer_auth_controller/lawyer_login_controller.dart';
import 'package:lawyer_app/features/lawyer/presentation/states/lawyer_auth_state/lawyer_login_state.dart';

final lawyerLoginProvider =
    StateNotifierProvider<LawyerLoginController, LawyerLoginState>(
      (ref) => LawyerLoginController(),
    );

