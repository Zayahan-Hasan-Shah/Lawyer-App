import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/client_controller/new_case_controller/new_case_controller.dart';
import 'package:lawyer_app/src/states/client_states/new_case_state/new_case_state.dart';

final newCaseProvider = StateNotifierProvider<NewCaseController, NewCaseState>((ref) {
  return NewCaseController();
});