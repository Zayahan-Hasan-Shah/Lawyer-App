import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/core/mock_data/student_research_data.dart';
import 'package:lawyer_app/src/models/student_model/research_model.dart';
import 'package:lawyer_app/src/states/student_states/research_states.dart';

class ResearchController extends StateNotifier<ResearchStates> {
  ResearchController() : super(ResearchInitialState());

  Future<void> getAllResearch() async {
    state = ResearchLoadingState();
    try {
      await Future.delayed(const Duration(seconds: 1));

      final response = mockStudentResearchData;
      if (response['status'] != 200) {
        state = ResearchFailureState(error: 'Failed to load research topics');
        return;
      }

      final data = response['data'] as Map<String, dynamic>;

      final currentList = (data['current_research'] as List)
          .map((e) => ResearchModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final availableList = (data['available_research'] as List)
          .map((e) => ResearchModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final allResearch = AllResearchResponse(
        currentResearch: currentList,
        availableResearch: availableList,
      );

      state = ResearchSuccessState(data: allResearch);
    } catch (e, stack) {
      log('Get All Research → Error: $e\n$stack');
      state = ResearchFailureState(error: 'Unable to load research data');
    }
  }

  Future<void> joinResearch(String researchId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (state is ResearchSuccessState) {
        final currentData = (state as ResearchSuccessState).data;
        final currentResearch = List<ResearchModel>.from(currentData.currentResearch);
        final availableResearch = List<ResearchModel>.from(currentData.availableResearch);

        final researchToJoin = availableResearch.firstWhere(
          (research) => research.id == researchId,
          orElse: () => throw Exception('Research not found'),
        );

        // Move research from available to current
        final joinedResearch = ResearchModel(
          id: researchToJoin.id,
          title: researchToJoin.title,
          description: researchToJoin.description,
          startDate: researchToJoin.startDate,
          status: 'active',
          supervisor: researchToJoin.supervisor,
        );

        currentResearch.add(joinedResearch);
        availableResearch.removeWhere((research) => research.id == researchId);

        final updatedData = AllResearchResponse(
          currentResearch: currentResearch,
          availableResearch: availableResearch,
        );

        state = ResearchSuccessState(data: updatedData);
      }
    } catch (e, stack) {
      log('Join Research → Error: $e\n$stack');
      state = ResearchFailureState(error: 'Failed to join research topic');
    }
  }

  Future<void> refreshResearch() async {
    await getAllResearch();
  }
}
