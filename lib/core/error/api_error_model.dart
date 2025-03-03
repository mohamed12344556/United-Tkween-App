import 'package:json_annotation/json_annotation.dart';

part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  bool? data;
  @JsonKey(name: 'isSuccess')
  bool? status;
  @JsonKey(name: 'error')
  ErrorData? errorMessage;

  ApiErrorModel({
    this.data,
    this.status,
    required this.errorMessage,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);
}

@JsonSerializable()
class ErrorData {
  @JsonKey(name: 'description')
  String? message;
  @JsonKey(name: 'statusCode')
  int? code;

  ErrorData({
    this.message,
    this.code,
  });

  factory ErrorData.fromJson(Map<String, dynamic> json) =>
      _$ErrorDataFromJson(json);
}
