// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileHiveModelAdapter extends TypeAdapter<ProfileHiveModel> {
  @override
  final int typeId = 10;

  @override
  ProfileHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileHiveModel(
      id: fields[0] as String,
      fullName: fields[1] as String,
      email: fields[2] as String,
      phoneNumber1: fields[3] as String?,
      phoneNumber2: fields[4] as String?,
      address: fields[5] as String?,
      profileImageUrl: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneNumber1)
      ..writeByte(4)
      ..write(obj.phoneNumber2)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.profileImageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
