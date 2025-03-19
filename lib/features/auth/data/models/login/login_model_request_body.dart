import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user_login_entity.dart';

part 'login_model_request_body.g.dart';

@JsonSerializable()
class LoginRequestModel extends UserLoginEntity {
  LoginRequestModel({required super.email, required super.password});

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) => _$LoginRequestModelFromJson(json);
}
