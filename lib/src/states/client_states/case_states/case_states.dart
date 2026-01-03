import 'package:lawyer_app/src/models/client_model/case_model/case_model.dart';

sealed class CaseStates {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(String error) failure,
    required R Function(AllCasesResponse data) success,
  }) {
    if (this is CaseInitialState) return initial();
    if (this is CaseLoadingState) return loading();
    if (this is CaseFailureState) {
      return failure((this as CaseFailureState).error);
    }
    if (this is CaseSuccessState) {
      return success((this as CaseSuccessState).data);
    }
    throw Exception('Unhandled state: $this');
  }
}

class CaseInitialState extends CaseStates {}

class CaseLoadingState extends CaseStates {}

class CaseSuccessState extends CaseStates {
  final AllCasesResponse data;
  CaseSuccessState({required this.data});
}

class CaseFailureState extends CaseStates {
  final String error;
  CaseFailureState({required this.error});
}
