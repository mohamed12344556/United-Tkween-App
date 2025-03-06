// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserOrderModel _$UserOrderModelFromJson(Map<String, dynamic> json) =>
    UserOrderModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      orderDate: DateTime.parse(json['orderDate'] as String),
      statusString: json['status'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$UserOrderModelToJson(UserOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'orderDate': instance.orderDate.toIso8601String(),
      'status': instance.statusString,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
    };
