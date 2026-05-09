sealed class StudentLoginState {
  const StudentLoginState();
}

class StudentLoginInitial extends StudentLoginState {}

class StudentLoginLoading extends StudentLoginState {}

class StudentLoginSuccess extends StudentLoginState {
  final String fullName;
  final String token;
  final String message;

  const StudentLoginSuccess({
    required this.fullName,
    this.message = "Student Login Successfull",
    required this.token,
  });
}

class StudentLoginFailure extends StudentLoginState {
  final String error;
  const StudentLoginFailure(this.error);
}
