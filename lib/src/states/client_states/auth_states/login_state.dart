sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String fullName;
  final String token;
  final String message;

  const LoginSuccess({
    required this.fullName,
    required this.token,
    this.message = 'Login Successful',
  });
}

class LoginFailure extends LoginState {
  final String error;
  const LoginFailure(this.error);
}
