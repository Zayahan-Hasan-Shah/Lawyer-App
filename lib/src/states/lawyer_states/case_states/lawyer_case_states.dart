import 'package:lawyer_app/src/models/lawyer_model/case_model/lawyer_case_model.dart';

sealed class LawyerCaseStates {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(String error) failure,
    required R Function(AllLawyerCasesResponse data) success,
  }) {
    if (this is LawyerCaseInitialState) return initial();
    if (this is LawyerCaseLoadingState) return loading();
    if (this is LawyerCaseFailureState) {
      return failure((this as LawyerCaseFailureState).error);
    }
    if (this is LawyerCaseSuccessState) {
      return success((this as LawyerCaseSuccessState).data);
    }
    throw Exception('Unhandled state: $this');
  }
}

class LawyerCaseInitialState extends LawyerCaseStates {}

class LawyerCaseLoadingState extends LawyerCaseStates {}

class LawyerCaseSuccessState extends LawyerCaseStates {
  final AllLawyerCasesResponse data;
  LawyerCaseSuccessState({required this.data});
}

class LawyerCaseFailureState extends LawyerCaseStates {
  final String error;
  LawyerCaseFailureState({required this.error});
}
