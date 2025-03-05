part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

// Initial state when the login screen is first loaded
class LoginInitial extends LoginState {}

// State during login process (showing loading indicator)
class LoginLoading extends LoginState {}

// State when login is successful
class LoginSuccess extends LoginState {
  final String userID;
  final String userToken;

  LoginSuccess({required this.userID, required this.userToken});
}

// State when login fails
class LoginError extends LoginState {
  final String errorMessage;

  LoginError({required this.errorMessage});
}