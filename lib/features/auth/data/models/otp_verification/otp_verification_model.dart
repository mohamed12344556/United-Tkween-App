import 'package:json_annotation/json_annotation.dart';

part 'otp_verification_model.g.dart';

@JsonSerializable()
class OtpVerificationModel {
  final String email;
  final String otp;

  OtpVerificationModel({
    required this.email,
    required this.otp,
  });

  factory OtpVerificationModel.fromJson(Map<String, dynamic> json) =>
      _$OtpVerificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerificationModelToJson(this);
}