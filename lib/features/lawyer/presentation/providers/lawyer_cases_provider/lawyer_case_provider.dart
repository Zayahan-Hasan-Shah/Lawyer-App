import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/lawyer/presentation/controllers/cases_controller/lawyer_case_controller.dart';
import 'package:lawyer_app/features/lawyer/presentation/states/case_states/lawyer_case_states.dart';

final lawyerCaseControllerProvider =
    StateNotifierProvider<LawyerCaseController, LawyerCaseStates>((ref) {
  return LawyerCaseController();
});

