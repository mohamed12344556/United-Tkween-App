import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_order_entity.dart';

part 'user_order_model.g.dart';

@JsonSerializable()
class UserOrderModel extends UserOrderEntity {
  @JsonKey(name: 'id')
  final String id;
  
  @JsonKey(name: 'title')
  final String title;
  
  @JsonKey(name: 'description')
  final String? description;
  
  @JsonKey(name: 'orderDate')
  final DateTime orderDate;
  
  @JsonKey(name: 'status')
  final String statusString;
  
  @JsonKey(name: 'price')
  final double price;
  
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;

  UserOrderModel({
    required this.id,
    required this.title,
    this.description,
    required this.orderDate,
    required this.statusString,
    required this.price,
    this.imageUrl,
  }) : super(
          id: id,
          title: title,
          description: description,
          orderDate: orderDate,
          status: _mapStringToStatus(statusString),
          price: price,
          imageUrl: imageUrl,
        );

  factory UserOrderModel.fromJson(Map<String, dynamic> json) =>
      _$UserOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserOrderModelToJson(this);

  factory UserOrderModel.fromEntity(UserOrderEntity entity) {
    return UserOrderModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      orderDate: entity.orderDate,
      statusString: _mapStatusToString(entity.status),
      price: entity.price,
      imageUrl: entity.imageUrl,
    );
  }

  UserOrderEntity toEntity() {
    return UserOrderEntity(
      id: id,
      title: title,
      description: description,
      orderDate: orderDate,
      status: _mapStringToStatus(statusString),
      price: price,
      imageUrl: imageUrl,
    );
  }

  static OrderStatus _mapStringToStatus(String statusString) {
    switch (statusString.toLowerCase()) {
      case 'processing':
      case 'قيد المعالجة':
        return OrderStatus.processing;
      case 'shipped':
      case 'تم الشحن':
      case 'في الطريق':
        return OrderStatus.shipped;
      case 'delivered':
      case 'تم التوصيل':
        return OrderStatus.delivered;
      case 'cancelled':
      case 'ملغي':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.processing;
    }
  }

  static String _mapStatusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }
}