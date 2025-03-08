// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryItemModel _$LibraryItemModelFromJson(Map<String, dynamic> json) =>
    LibraryItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      orderDate: DateTime.parse(json['orderDate'] as String),
      typeString: json['type'] as String,
      price: (json['price'] as num).toDouble(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      fileUrl: json['fileUrl'] as String?,
      isDelivered: json['isDelivered'] as bool,
    );

Map<String, dynamic> _$LibraryItemModelToJson(LibraryItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'orderDate': instance.orderDate.toIso8601String(),
      'type': instance.typeString,
      'price': instance.price,
      'thumbnailUrl': instance.thumbnailUrl,
      'fileUrl': instance.fileUrl,
      'isDelivered': instance.isDelivered,
    };
