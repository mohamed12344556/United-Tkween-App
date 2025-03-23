part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFormUpdated extends LoginState {}

class LoginSuccess extends LoginState {
 final LoginModelResponse loginModelResponse;

  LoginSuccess({required this.loginModelResponse});
}

class LoginError extends LoginState {
  final String errorMessage;

  LoginError({required this.errorMessage});
}