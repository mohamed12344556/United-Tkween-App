import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_reset_password_entity.dart';

part 'reset_password_model.g.dart';

@JsonSerializable()
class ResetPasswordModel extends UserResetPasswordEntity {
  final String email;
  final String resetToken;
  final String password;
  final String passwordConfirmation;

  ResetPasswordModel({
    required this.email,
    required this.resetToken,
    required this.password,
    required this.passwordConfirmation,
  }) : super(
          email: email,
          resetToken: resetToken,
          password: password,
          passwordConfirmation: passwordConfirmation,
        );

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordModelToJson(this);
}