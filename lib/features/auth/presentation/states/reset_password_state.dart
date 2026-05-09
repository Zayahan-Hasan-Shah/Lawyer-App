sealed class ResetPasswordState {
  const ResetPasswordState();
}

class ResetPasswordStateInitial extends ResetPasswordState{}
class ResetPasswordStateLoading extends ResetPasswordState{}
class ResetPasswordStateSuccess extends ResetPasswordState{
  final String message;
  const ResetPasswordStateSuccess(this.message);
}
class ResetPasswordStateFailure extends ResetPasswordState{
  final String error;
  const ResetPasswordStateFailure(this.error);
}