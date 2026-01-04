import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/core/mock_data/lawyer_profile_data.dart';
import 'package:lawyer_app/src/states/lawyer_states/profile_states/lawyer_profile_states.dart';

class LawyerProfileController extends StateNotifier<LawyerProfileState> {
  LawyerProfileController() : super(LawyerProfileInitial());

  Future<void> loadProfile() async {
    state = LawyerProfileLoading();
    try {
      // Simulate API latency
      await Future.delayed(const Duration(milliseconds: 600));

      // In real app, call API here. For now, use mock profile.
      state = LawyerProfileSuccess(data: mockLawyerSelfProfile);
    } catch (e, stack) {
      log('Load Lawyer Profile → Error: $e\n$stack');
      state = LawyerProfileFailure(error: 'Unable to load profile');
    }
  }
}
