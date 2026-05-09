import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/lawyer/presentation/controllers/profile_controller/lawyer_profile_controller.dart';
import 'package:lawyer_app/features/lawyer/presentation/states/profile_states/lawyer_profile_states.dart';

final lawyerProfileProvider =
    StateNotifierProvider<LawyerProfileController, LawyerProfileState>((ref) {
  return LawyerProfileController();
});

