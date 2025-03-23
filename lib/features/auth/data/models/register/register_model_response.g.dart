// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterModelResponse _$RegisterModelResponseFromJson(
        Map<String, dynamic> json) =>
    RegisterModelResponse(
      status: json['status'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$RegisterModelResponseToJson(
        RegisterModelResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
