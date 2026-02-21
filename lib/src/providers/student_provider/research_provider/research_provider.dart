import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/student_controller/research_controller/research_controller.dart';
import 'package:lawyer_app/src/states/student_states/research_states.dart';

final researchControllerProvider =
    StateNotifierProvider<ResearchController, ResearchStates>((ref) {
  return ResearchController();
});
