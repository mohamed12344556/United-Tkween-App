// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_model_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterModelRequestBody _$RegisterModelRequestBodyFromJson(
        Map<String, dynamic> json) =>
    RegisterModelRequestBody(
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$RegisterModelRequestBodyToJson(
        RegisterModelRequestBody instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'address': instance.address,
      'full_name': instance.fullName,
      'phone': instance.phone,
    };
