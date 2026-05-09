import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/lawyer/presentation/controllers/lawyer_auth_controller/lawyer_signup_controller.dart';
import 'package:lawyer_app/features/lawyer/presentation/states/lawyer_auth_state/lawyer_signup_state.dart';

final lawyerSignupProvider =
    StateNotifierProvider<LawyerSignupController, LawyerSignupState>(
      (ref) => LawyerSignupController(),
    );

