// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber1: json['phoneNumber1'] as String?,
      phoneNumber2: json['phoneNumber2'] as String?,
      address: json['address'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber1': instance.phoneNumber1,
      'phoneNumber2': instance.phoneNumber2,
      'address': instance.address,
      'profileImageUrl': instance.profileImageUrl,
    };
