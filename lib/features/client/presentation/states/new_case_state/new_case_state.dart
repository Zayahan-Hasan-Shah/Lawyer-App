sealed class NewCaseState {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(String message) success,
    required R Function(String error) failure,
  }) {
    if (this is NewCaseInitial) return initial();
    if (this is NewCaseLoading) return loading();
    if (this is NewCaseSuccess) {
      return success((this as NewCaseSuccess).message);
    }
    if (this is NewCaseFailure) return failure((this as NewCaseFailure).error);
    throw Exception('Unhandled state');
  }
}

class NewCaseInitial extends NewCaseState {}

class NewCaseLoading extends NewCaseState {}

class NewCaseSuccess extends NewCaseState {
  final String message;
  NewCaseSuccess(this.message);
}

class NewCaseFailure extends NewCaseState {
  final String error;
  NewCaseFailure(this.error);
}
