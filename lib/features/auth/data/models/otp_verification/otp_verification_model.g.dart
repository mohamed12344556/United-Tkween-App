// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpVerificationModel _$OtpVerificationModelFromJson(
        Map<String, dynamic> json) =>
    OtpVerificationModel(
      email: json['email'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$OtpVerificationModelToJson(
        OtpVerificationModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'otp': instance.otp,
    };
