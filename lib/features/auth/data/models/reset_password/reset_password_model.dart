import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/user_reset_password_entity.dart';

part 'reset_password_model.g.dart';

@JsonSerializable()
class ResetPasswordModel extends UserResetPasswordEntity {
  ResetPasswordModel({
    required super.email,
    required super.password,
    required super.passwordConfirmation,
  });

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordModelToJson(this);
}
