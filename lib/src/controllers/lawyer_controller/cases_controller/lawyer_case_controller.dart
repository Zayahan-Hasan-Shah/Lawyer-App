import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/core/mock_data/lawyer_cases_data.dart';
import 'package:lawyer_app/src/models/lawyer_model/case_model/lawyer_case_model.dart';
import 'package:lawyer_app/src/states/lawyer_states/case_states/lawyer_case_states.dart';

class LawyerCaseController extends StateNotifier<LawyerCaseStates> {
  LawyerCaseController() : super(LawyerCaseInitialState());

  Future<void> getAllCases() async {
    state = LawyerCaseLoadingState();
    try {
      await Future.delayed(const Duration(seconds: 1));

      final response = mockLawyerCasesData;
      if (response['status'] != 200) {
        state = LawyerCaseFailureState(error: 'Failed to load lawyer cases');
        return;
      }

      final data = response['data'] as Map<String, dynamic>;

      final pendingList = (data['pending_cases'] as List)
          .map((e) => LawyerCaseModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final disposedList = (data['disposed_cases'] as List)
          .map((e) => LawyerCaseModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final allCases = AllLawyerCasesResponse(
        pendingCases: pendingList,
        disposedCases: disposedList,
      );

      state = LawyerCaseSuccessState(data: allCases);
    } catch (e, stack) {
      log('Get All Lawyer Cases → Error: $e\n$stack');
      state =
          LawyerCaseFailureState(error: 'Unable to load lawyer dashboard data');
    }
  }
}
