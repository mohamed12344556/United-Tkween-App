// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiErrorModel _$ApiErrorModelFromJson(Map<String, dynamic> json) =>
    ApiErrorModel(
      data: json['data'] as bool?,
      status: json['isSuccess'] as bool?,
      errorMessage:
          json['error'] == null
              ? null
              : ErrorData.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiErrorModelToJson(ApiErrorModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'isSuccess': instance.status,
      'error': instance.errorMessage,
    };

ErrorData _$ErrorDataFromJson(Map<String, dynamic> json) => ErrorData(
  message: json['description'] as String?,
  code: (json['statusCode'] as num?)?.toInt(),
);

Map<String, dynamic> _$ErrorDataToJson(ErrorData instance) => <String, dynamic>{
  'description': instance.message,
  'statusCode': instance.code,
};
