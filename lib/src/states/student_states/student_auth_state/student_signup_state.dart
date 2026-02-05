sealed class StudentSignupState {
  const StudentSignupState();
}

class StudentSignupInitial extends StudentSignupState {}

class StudentSignupLoading extends StudentSignupState {}

class StudentSignupSuccess extends StudentSignupState {
  final String message;
  const StudentSignupSuccess(this.message);
}

class StudentSignupFailure extends StudentSignupState {
  final String error;
  const StudentSignupFailure(this.error);
}
