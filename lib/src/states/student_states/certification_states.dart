import 'package:lawyer_app/src/models/student_model/certification_model.dart';

sealed class CertificationStates {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(String error) failure,
    required R Function(AllCertificationsResponse data) success,
  }) {
    if (this is CertificationInitialState) return initial();
    if (this is CertificationLoadingState) return loading();
    if (this is CertificationFailureState) {
      return failure((this as CertificationFailureState).error);
    }
    if (this is CertificationSuccessState) {
      return success((this as CertificationSuccessState).data);
    }
    throw Exception('Unhandled state: $this');
  }
}

class CertificationInitialState extends CertificationStates {}

class CertificationLoadingState extends CertificationStates {}

class CertificationSuccessState extends CertificationStates {
  final AllCertificationsResponse data;
  CertificationSuccessState({required this.data});
}

class CertificationFailureState extends CertificationStates {
  final String error;
  CertificationFailureState({required this.error});
}
