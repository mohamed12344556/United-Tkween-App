part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String userID;
  final String userToken;

  LoginSuccess({required this.userID, required this.userToken});
}

class LoginError extends LoginState {
  final String errorMessage;

  LoginError({required this.errorMessage});
}
