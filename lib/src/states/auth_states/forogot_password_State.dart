sealed class ForgotPasswordState {
  const ForgotPasswordState();
}

class ForgotPasswordInitial extends ForgotPasswordState{}
class ForgotPasswordLoading extends ForgotPasswordState{}
class ForgotPasswordSuccess extends ForgotPasswordState{
  final String message;
  const ForgotPasswordSuccess(this.message);
}
class ForgotPasswordFailure extends ForgotPasswordState{
  final String error;
  const ForgotPasswordFailure(this.error);
}