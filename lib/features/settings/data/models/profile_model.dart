import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/profile_entity.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel extends ProfileEntity {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'fullName')
  final String fullName;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'phoneNumber1')
  final String? phoneNumber1;

  @JsonKey(name: 'phoneNumber2')
  final String? phoneNumber2;

  @JsonKey(name: 'address')
  final String? address;

  @JsonKey(name: 'profileImageUrl')
  final String? profileImageUrl;

  const ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber1,
    this.phoneNumber2,
    this.address,
    this.profileImageUrl,
  }) : super(
         id: id,
         fullName: fullName,
         email: email,
         phoneNumber1: phoneNumber1,
         phoneNumber2: phoneNumber2,
         address: address,
         profileImageUrl: profileImageUrl,
       );

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber1: entity.phoneNumber1,
      phoneNumber2: entity.phoneNumber2,
      address: entity.address,
      profileImageUrl: entity.profileImageUrl,
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      fullName: fullName,
      email: email,
      phoneNumber1: phoneNumber1,
      phoneNumber2: phoneNumber2,
      address: address,
      profileImageUrl: profileImageUrl,
    );
  }
}
