import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_login_entity.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel extends UserLoginEntity {
  final String email;
  final String password;

  LoginModel({required this.email, required this.password})
    : super(email: email, password: password);

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      _$LoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
