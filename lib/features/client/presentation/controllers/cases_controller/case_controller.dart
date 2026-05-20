import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/client/data/models/case_model/case_model.dart';
import 'package:lawyer_app/features/client/domain/usecases/client_usecases.dart';
import 'package:lawyer_app/features/client/presentation/states/case_states/case_states.dart';

class CaseController extends StateNotifier<CaseStates> {
  final GetCasesByUserIdUseCase _getCasesUseCase;

  CaseController({GetCasesByUserIdUseCase? getCasesUseCase})
      : _getCasesUseCase = getCasesUseCase ?? sl<GetCasesByUserIdUseCase>(),
        super(CaseInitialState());

  Future<void> getAllCases() async {
    state = CaseLoadingState();
    try {
      final int? userId = await StorageService.instance.getUserId();
      if (userId == null) {
        state = CaseFailureState(error: "User not logged in");
        return;
      }

      final response = await _getCasesUseCase.execute(userId);

      if (response != null && response['status'] == 'success') {
        final Map<String, dynamic> dataMap = response['data'] as Map<String, dynamic>;
        final List<dynamic> casesList = dataMap['items'] as List<dynamic>;

        final List<CaseModel> allCasesList = casesList.map((item) {
          final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
          final Map<String, dynamic> map = (itemMap['caseInfo'] ?? itemMap) as Map<String, dynamic>;
          final List<dynamic> rawNotes = itemMap['notes'] as List<dynamic>? ?? [];
          final notes = rawNotes
              .map((n) => CaseNote.fromJson(n as Map<String, dynamic>))
              .toList();
          return CaseModel.fromJson(map, notes: notes);
        }).toList();

        final pendingList = allCasesList.where((c) {
          final s = c.status.toLowerCase();
          return s != 'disposed' && s != 'closed' && s != 'disposed';
        }).toList();

        final disposedList = allCasesList.where((c) {
          final s = c.status.toLowerCase();
          return s == 'disposed' || s == 'closed' || s == 'disposed';
        }).toList();

        final allCases = AllCasesResponse(
          pendingCases: pendingList,
          disposedCases: disposedList,
        );

        state = CaseSuccessState(data: allCases);
      } else {
        final errorMsg = response != null ? response['errorMessage'] : "Server error";
        state = CaseFailureState(error: errorMsg ?? "Failed to load cases");
      }
    } catch (e, stack) {
      log("Get All Cases → Error: $e\n$stack");
      state = CaseFailureState(error: "Unable to load cases. Please check your internet connection and try again.");
    }
  }
}

