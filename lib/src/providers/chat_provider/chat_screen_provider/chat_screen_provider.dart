import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/lawyer_controller/lawyer_controller.dart';
import 'package:lawyer_app/src/states/lawyer_states/lawyer_state.dart';

final chatScreenProvider = StateNotifierProvider<LawyerController, LawyerState>(
  (ref) => LawyerController(),
);
