import 'package:json_annotation/json_annotation.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_register_entity.dart';

part 'register_model_request_body.g.dart';

@JsonSerializable()
class RegisterModelRequestBody extends UserRegisterEntity {
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(defaultValue: "1111111")
  final String? phone;

  @override
  @JsonKey(defaultValue: "Default Address")
  final String? address;

  RegisterModelRequestBody({
    required this.fullName,
    required super.email,
    this.phone,
    required super.password,
    this.address,
  }) : super(fullName: fullName, phoneNumber: phone, address: address);

  factory RegisterModelRequestBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterModelRequestBodyToJson(this);
}
