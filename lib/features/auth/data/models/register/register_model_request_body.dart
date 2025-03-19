import 'package:json_annotation/json_annotation.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_register_entity.dart';

part 'register_model_request_body.g.dart';

@JsonSerializable()
class RegisterModelRequestBody extends UserRegisterEntity {
  @JsonKey(name: 'full_name')
  final String fullName;
  final String phone;


  RegisterModelRequestBody({
    required this.fullName,
    required super.email,
    required this.phone,
    required super.password,
    required super.address,
  }) : super(fullName: fullName, phoneNumber: phone);

  factory RegisterModelRequestBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterModelRequestBodyToJson(this);
}
