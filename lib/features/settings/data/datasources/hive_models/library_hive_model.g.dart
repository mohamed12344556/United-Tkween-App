// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LibraryHiveModelAdapter extends TypeAdapter<LibraryHiveModel> {
  @override
  final int typeId = 12;

  @override
  LibraryHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LibraryHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      orderDate: fields[3] as DateTime,
      typeString: fields[4] as String,
      price: fields[5] as double,
      thumbnailUrl: fields[6] as String?,
      fileUrl: fields[7] as String?,
      isDelivered: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LibraryHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.orderDate)
      ..writeByte(4)
      ..write(obj.typeString)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.thumbnailUrl)
      ..writeByte(7)
      ..write(obj.fileUrl)
      ..writeByte(8)
      ..write(obj.isDelivered);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
