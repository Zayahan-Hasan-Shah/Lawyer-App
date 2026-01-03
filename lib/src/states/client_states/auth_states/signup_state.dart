sealed class SignupState {
  const SignupState();
}

class SignupInitial extends SignupState{}
class SignupLoading extends SignupState{}
class SignupSuccess extends SignupState{
  final String message;
  const SignupSuccess(this.message);
}
class SignupFailure extends SignupState{
  final String error;
  const SignupFailure(this.error);
}