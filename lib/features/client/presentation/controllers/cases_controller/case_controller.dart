import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/constants/app_keys.dart';
import 'package:lawyer_app/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/client/domain/entities/case_entity.dart';
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
      final dynamic rawUserId = await StorageService.instance.read(AppKeys.userIdKey);
      final int? userId = rawUserId != null ? int.tryParse(rawUserId.toString()) : null;
      if (userId == null) {
        state = CaseFailureState(error: "User not logged in");
        return;
      }

      final List<CaseEntity> allCasesList = await _getCasesUseCase.execute(userId);

      final pendingList = allCasesList.where((c) {
        final s = c.status.toLowerCase();
        return s != 'disposed' && s != 'closed';
      }).toList();

      final disposedList = allCasesList.where((c) {
        final s = c.status.toLowerCase();
        return s == 'disposed' || s == 'closed';
      }).toList();

      final allCases = AllCasesResponse(
        pendingCases: pendingList,
        disposedCases: disposedList,
      );

      state = CaseSuccessState(data: allCases);
    } catch (e, stack) {
      log("Get All Cases → Error: $e\n$stack");
      state = CaseFailureState(error: "Unable to load cases. Please check your internet connection and try again.");
    }
  }
}
