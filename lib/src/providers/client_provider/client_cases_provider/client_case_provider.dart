import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/client_controller/cases_controller/case_controller.dart';
import 'package:lawyer_app/src/states/case_states/case_states.dart';

final caseControllerProvider =
    StateNotifierProvider<CaseController, CaseStates>((ref) {
      return CaseController();
    });
