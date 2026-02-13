// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderHiveModelAdapter extends TypeAdapter<OrderHiveModel> {
  @override
  final int typeId = 11;

  @override
  OrderHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      orderDate: fields[3] as DateTime,
      statusString: fields[4] as String,
      price: fields[5] as double,
      imageUrl: fields[6] as String?,
      chargeId: fields[7] as String?,
      booksJson: fields[8] as String?,
      customerJson: fields[9] as String?,
      paymentJson: fields[10] as String?,
      priceSummaryJson: fields[11] as String?,
      shippingJson: fields[12] as String?,
      shippingAddress: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderHiveModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.orderDate)
      ..writeByte(4)
      ..write(obj.statusString)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.chargeId)
      ..writeByte(8)
      ..write(obj.booksJson)
      ..writeByte(9)
      ..write(obj.customerJson)
      ..writeByte(10)
      ..write(obj.paymentJson)
      ..writeByte(11)
      ..write(obj.priceSummaryJson)
      ..writeByte(12)
      ..write(obj.shippingJson)
      ..writeByte(13)
      ..write(obj.shippingAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
