import 'package:hive/hive.dart';
import '../../../domain/entities/profile_entity.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: 10)
class ProfileHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? phoneNumber1;

  @HiveField(4)
  final String? phoneNumber2;

  @HiveField(5)
  final String? address;

  @HiveField(6)
  final String? profileImageUrl;

  ProfileHiveModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber1,
    this.phoneNumber2,
    this.address,
    this.profileImageUrl,
  });

  // تحويل من نموذج الكيان إلى نموذج Hive
  factory ProfileHiveModel.fromProfileEntity(ProfileEntity entity) {
    return ProfileHiveModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber1: entity.phoneNumber1,
      phoneNumber2: entity.phoneNumber2,
      address: entity.address,
      profileImageUrl: entity.profileImageUrl,
    );
  }

  // تحويل من نموذج Hive إلى نموذج الكيان
  ProfileEntity toProfileEntity() {
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