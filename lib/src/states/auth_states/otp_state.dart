sealed class OtpState {
  const OtpState();
}

class OtpStateInitial extends OtpState{}
class OtpStateLoading extends OtpState{}
class OtpStateSuccess extends OtpState{
  final String message;
  const OtpStateSuccess(this.message);
}
class OtpStateFailure extends OtpState{
  final String error;
  const OtpStateFailure(this.error);
}