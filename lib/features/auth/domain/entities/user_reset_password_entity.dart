class UserResetPasswordEntity {
  final String email;
  final String password;
  final String passwordConfirmation;

  UserResetPasswordEntity({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
}
