import 'package:json_annotation/json_annotation.dart';

part 'register_model_response.g.dart';

@JsonSerializable()
class RegisterModelResponse {
  final String status;
  final String message;

  RegisterModelResponse({required this.status, required this.message});
  factory RegisterModelResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterModelResponseToJson(this);
}
