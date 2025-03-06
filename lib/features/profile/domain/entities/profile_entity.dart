import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber1;
  final String? phoneNumber2;
  final String? address;
  final String? profileImageUrl;
  
  const ProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber1,
    this.phoneNumber2,
    this.address,
    this.profileImageUrl,
  });
  
  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phoneNumber1,
    phoneNumber2,
    address,
    profileImageUrl,
  ];
  
  ProfileEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber1,
    String? phoneNumber2,
    String? address,
    String? profileImageUrl,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber1: phoneNumber1 ?? this.phoneNumber1,
      phoneNumber2: phoneNumber2 ?? this.phoneNumber2,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}