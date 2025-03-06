import 'package:json_annotation/json_annotation.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_login_entity.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel extends UserLoginEntity {
  @JsonKey(defaultValue: '')
  final String email;

  @JsonKey(defaultValue: '')
  final String password;

  LoginModel({required this.email, required this.password})
    : super(email: email, password: password);

  // factory LoginModel.fromJson(Map<String, dynamic> json) =>
  //     _$LoginModelFromJson(json);
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    print('LoginModel JSON: $json');
    return LoginModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
