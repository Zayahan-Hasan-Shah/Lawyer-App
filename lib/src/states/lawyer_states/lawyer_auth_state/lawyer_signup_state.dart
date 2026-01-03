sealed class LawyerSignupState {
  const LawyerSignupState();
}

class LawyerSignupInitial extends LawyerSignupState {}

class LawyerSignupLoading extends LawyerSignupState {}

class LawyerSignupSuccess extends LawyerSignupState {
  final String message;
  const LawyerSignupSuccess(this.message);
}

class LawyerSignupFailure extends LawyerSignupState {
  final String error;
  const LawyerSignupFailure(this.error);
}
