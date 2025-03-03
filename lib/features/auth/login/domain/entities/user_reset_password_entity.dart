class UserResetPasswordEntity {
  final String email;
  final String resetToken;
  final String password;
  final String passwordConfirmation;

  UserResetPasswordEntity({
    required this.email,
    required this.resetToken,
    required this.password,
    required this.passwordConfirmation,
  });
}
