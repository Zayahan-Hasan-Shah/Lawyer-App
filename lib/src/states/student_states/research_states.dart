import 'package:lawyer_app/src/models/student_model/research_model.dart';

sealed class ResearchStates {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(String error) failure,
    required R Function(AllResearchResponse data) success,
  }) {
    if (this is ResearchInitialState) return initial();
    if (this is ResearchLoadingState) return loading();
    if (this is ResearchFailureState) {
      return failure((this as ResearchFailureState).error);
    }
    if (this is ResearchSuccessState) {
      return success((this as ResearchSuccessState).data);
    }
    throw Exception('Unhandled state: $this');
  }
}

class ResearchInitialState extends ResearchStates {}

class ResearchLoadingState extends ResearchStates {}

class ResearchSuccessState extends ResearchStates {
  final AllResearchResponse data;
  ResearchSuccessState({required this.data});
}

class ResearchFailureState extends ResearchStates {
  final String error;
  ResearchFailureState({required this.error});
}
