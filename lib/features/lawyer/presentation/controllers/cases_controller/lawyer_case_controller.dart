import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/constants/app_keys.dart';
import 'package:lawyer_app/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/client/domain/entities/case_entity.dart';
import 'package:lawyer_app/features/client/domain/usecases/client_usecases.dart';
import 'package:lawyer_app/features/lawyer/domain/entities/lawyer_case_entity.dart';
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
      final dynamic rawUserId = await StorageService.instance.read(AppKeys.userIdKey);
      final int? userId = rawUserId != null ? int.tryParse(rawUserId.toString()) : null;
      if (userId == null) {
        state = LawyerCaseFailureState(error: "User not logged in");
        return;
      }

      final List<CaseEntity> caseEntities = await _getCasesUseCase.execute(userId);

      final List<LawyerCaseModel> allCasesList = caseEntities
          .map((entity) => LawyerCaseModel.fromEntity(entity))
          .toList();

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
    } catch (e, stack) {
      log('Get All Lawyer Cases → Error: $e\n$stack');
      state = LawyerCaseFailureState(error: 'Unable to load lawyer dashboard data');
    }
  }
}
