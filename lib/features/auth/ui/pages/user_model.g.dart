// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      fullName: fields[2] as String?,
      age: fields[3] as int?,
      job: fields[4] as String?,
      gender: fields[5] as String?,
      points: fields[6] as int?,
      email: fields[7] as String?,
      password: fields[8] as String?,
      profilePicture: fields[9] as String?,
      fbToken: fields[10] as String?,
      token: fields[11] as String?,
      privacy: fields[12] as String?,
      smLogin: fields[13] as int?,
      smToken: fields[14] as String?,
      googleId: fields[15] as String?,
      facebookId: fields[16] as String?,
      message: fields[17] as String?,
      appleId: fields[19] as String?,
      birthday: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.job)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.points)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.password)
      ..writeByte(9)
      ..write(obj.profilePicture)
      ..writeByte(10)
      ..write(obj.fbToken)
      ..writeByte(11)
      ..write(obj.token)
      ..writeByte(12)
      ..write(obj.privacy)
      ..writeByte(13)
      ..write(obj.smLogin)
      ..writeByte(14)
      ..write(obj.smToken)
      ..writeByte(15)
      ..write(obj.googleId)
      ..writeByte(16)
      ..write(obj.facebookId)
      ..writeByte(17)
      ..write(obj.message)
      ..writeByte(18)
      ..write(obj.birthday)
      ..writeByte(19)
      ..write(obj.appleId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}