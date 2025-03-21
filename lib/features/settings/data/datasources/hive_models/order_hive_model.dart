import 'package:hive/hive.dart';
import '../../../domain/entities/user_order_entity.dart';

part 'order_hive_model.g.dart';

/// نموذج Hive للتخزين المحلي للطلبات
@HiveType(typeId: 11)
class OrderHiveModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String? description;
  
  @HiveField(3)
  final DateTime orderDate;
  
  @HiveField(4)
  final String statusString;
  
  @HiveField(5)
  final double price;
  
  @HiveField(6)
  final String? imageUrl;

  OrderHiveModel({
    required this.id,
    required this.title,
    this.description,
    required this.orderDate,
    required this.statusString,
    required this.price,
    this.imageUrl,
  });

  // تحويل من نموذج الطلب إلى نموذج Hive
  factory OrderHiveModel.fromUserOrderEntity(UserOrderEntity entity) {
    String statusToString(OrderStatus status) {
      switch (status) {
        case OrderStatus.processing: return 'processing';
        case OrderStatus.shipped: return 'shipped';
        case OrderStatus.delivered: return 'delivered';
        case OrderStatus.cancelled: return 'cancelled';
      }
    }

    return OrderHiveModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      orderDate: entity.orderDate,
      statusString: statusToString(entity.status),
      price: entity.price,
      imageUrl: entity.imageUrl,
    );
  }

  // تحويل من نموذج Hive إلى نموذج الكيان
  UserOrderEntity toUserOrderEntity() {
    OrderStatus stringToStatus(String statusString) {
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

    return UserOrderEntity(
      id: id,
      title: title,
      description: description,
      orderDate: orderDate,
      status: stringToStatus(statusString),
      price: price,
      imageUrl: imageUrl,
    );
  }
}