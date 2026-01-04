import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/lawyer_controller/profile_controller/lawyer_profile_controller.dart';
import 'package:lawyer_app/src/states/lawyer_states/profile_states/lawyer_profile_states.dart';

final lawyerProfileProvider =
    StateNotifierProvider<LawyerProfileController, LawyerProfileState>((ref) {
  return LawyerProfileController();
});
