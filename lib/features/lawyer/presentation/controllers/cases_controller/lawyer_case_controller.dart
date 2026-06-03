import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/client/domain/usecases/client_usecases.dart';
import 'package:lawyer_app/features/lawyer/data/models/case_model/lawyer_case_model.dart';
import 'package:lawyer_app/features/lawyer/presentation/states/case_states/lawyer_case_states.dart';

class LawyerCaseController extends StateNotifier<LawyerCaseStates> {
  final GetCasesByUserIdUseCase _getCasesUseCase;

  LawyerCaseController({GetCasesByUserIdUseCase? getCasesUseCase})
      : _getCasesUseCase = getCasesUseCase ?? sl<GetCasesByUserIdUseCase>(),
        super(LawyerCaseInitialState());

  Future<void> getAllCases() async {
    state = LawyerCaseLoadingState();
    try {
      final int? userId = await StorageService.instance.getUserId();
      if (userId == null) {
        state = LawyerCaseFailureState(error: "User not logged in");
        return;
      }

      final response = await _getCasesUseCase.execute(userId);

      if (response != null && response['status'] == 'success') {
        final Map<String, dynamic> dataMap = response['data'] as Map<String, dynamic>;
        final List<dynamic> casesList = dataMap['items'] as List<dynamic>;

        final List<LawyerCaseModel> allCasesList = casesList.map((item) {
          final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
          final Map<String, dynamic> map = (itemMap['caseInfo'] ?? itemMap) as Map<String, dynamic>;
          return LawyerCaseModel.fromJson(map);
        }).toList();

        final pendingList = allCasesList.where((c) {
          final s = c.status.toLowerCase();
          return s != 'disposed' && s != 'closed';
        }).toList();

        final disposedList = allCasesList.where((c) {
          final s = c.status.toLowerCase();
          return s == 'disposed' || s == 'closed';
        }).toList();

        final allCases = AllLawyerCasesResponse(
          pendingCases: pendingList,
          disposedCases: disposedList,
        );

        state = LawyerCaseSuccessState(data: allCases);
      } else {
        final errorMsg = response != null ? response['errorMessage'] : "Server error";
        state = LawyerCaseFailureState(error: errorMsg ?? "Failed to load lawyer cases");
      }
    } catch (e, stack) {
      log('Get All Lawyer Cases → Error: $e\n$stack');
      state = LawyerCaseFailureState(error: 'Unable to load lawyer dashboard data');
    }
  }
}

