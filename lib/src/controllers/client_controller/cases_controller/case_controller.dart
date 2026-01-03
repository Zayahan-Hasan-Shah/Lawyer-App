import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/core/mock_data/cases_data.dart';
import 'package:lawyer_app/src/models/client_model/case_model/case_model.dart';
import 'package:lawyer_app/src/states/client_states/case_states/case_states.dart';

class CaseController extends StateNotifier<CaseStates> {
  CaseController() : super(CaseInitialState());

  Future<void> getAllCases() async {
    state = CaseLoadingState();
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate API response
      final response = mockCasesData;

      if (response['status'] != 200) {
        state = CaseFailureState(error: "Failed to load cases");
      }

      final data = response['data'] as Map<String, dynamic>;

      final pendingList = (data['pending_cases'] as List)
          .map((e) => CaseModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final disposedList = (data['disposed_cases'] as List)
          .map((e) => CaseModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final allCases = AllCasesResponse(
        pendingCases: pendingList,
        disposedCases: disposedList,
      );

      state = CaseSuccessState(data: allCases);
    } catch (e, stack) {
      log("Get All Cases → Error: $e\n$stack");
      state = CaseFailureState(error: "Unable to Load Cases");
    }
  }
}
