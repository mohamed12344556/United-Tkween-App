import 'package:json_annotation/json_annotation.dart';

part 'login_model_response.g.dart';

@JsonSerializable()
class LoginModelResponse {
  final String status;
  final String message;
  final String? token;
  @JsonKey(name: 'user')
  final UserData? userData;

  LoginModelResponse({
    required this.status,
    required this.message,
     this.token,
     this.userData,
  });

  factory LoginModelResponse.fromJson(Map<String, dynamic> json) => 
      _$LoginModelResponseFromJson(json);

}

@JsonSerializable()
class UserData {
  final int id;
  final String name;
  final String email;
  final String role;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => 
      _$UserDataFromJson(json);

}