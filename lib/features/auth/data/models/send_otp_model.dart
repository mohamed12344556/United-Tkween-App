import 'package:json_annotation/json_annotation.dart';

part 'send_otp_model.g.dart';

@JsonSerializable()
class SendOtpModel {
  final String email;

  SendOtpModel({
    required this.email,
  });

  factory SendOtpModel.fromJson(Map<String, dynamic> json) =>
      _$SendOtpModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpModelToJson(this);
}