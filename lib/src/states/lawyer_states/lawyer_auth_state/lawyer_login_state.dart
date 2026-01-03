sealed class LawyerLoginState {
  const LawyerLoginState();
}

class LawyerLoginInitial extends LawyerLoginState {}

class LawyerLoginLoading extends LawyerLoginState {}

class LawyerLoginSuccess extends LawyerLoginState {
  final String fullName;
  final String token;
  final String message;

  const LawyerLoginSuccess({
    required this.fullName,
    required this.token,
    this.message = 'Lawyer Login Successful',
  });
}

class LawyerLoginFailure extends LawyerLoginState {
  final String error;
  const LawyerLoginFailure(this.error);
}
