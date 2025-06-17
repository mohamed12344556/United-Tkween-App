// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModelResponse _$LoginModelResponseFromJson(Map<String, dynamic> json) =>
    LoginModelResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      token: json['token'] as String?,
      userData: json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginModelResponseToJson(LoginModelResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'token': instance.token,
      'user': instance.userData,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
    };
