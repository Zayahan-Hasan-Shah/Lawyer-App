import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/lawyer_controller/cases_controller/lawyer_case_controller.dart';
import 'package:lawyer_app/src/states/lawyer_states/case_states/lawyer_case_states.dart';

final lawyerCaseControllerProvider =
    StateNotifierProvider<LawyerCaseController, LawyerCaseStates>((ref) {
  return LawyerCaseController();
});
