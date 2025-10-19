import 'package:lawyer_app/src/models/user_model/user_model.dart';

sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState{}
class LoginLoading extends LoginState{}
class LoginSuccess extends LoginState{
  final UserModel user;
  const LoginSuccess(this.user);
}
class LoginFailure extends LoginState{
  final String error;
  const LoginFailure(this.error);
}