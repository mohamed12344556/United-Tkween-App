import 'package:equatable/equatable.dart';

enum OrderStatus {
  processing,
  shipped,
  delivered,
  cancelled,
}

class UserOrderEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime orderDate;
  final OrderStatus status;
  final double price;
  final String? imageUrl;
  
  const UserOrderEntity({
    required this.id,
    required this.title,
    this.description,
    required this.orderDate,
    required this.status,
    required this.price,
    this.imageUrl,
  });
  
  @override
  List<Object?> get props => [
    id, 
    title, 
    description, 
    orderDate, 
    status, 
    price, 
    imageUrl,
  ];
  
  String get formattedDate {
    return '${orderDate.day}-${orderDate.month}-${orderDate.year}';
  }
  
  String get statusText {
    switch (status) {
      case OrderStatus.processing:
        return 'قيد المعالجة';
      case OrderStatus.shipped:
        return 'تم الشحن';
      case OrderStatus.delivered:
        return 'تم التوصيل';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }
  
  bool get isDelivered => status == OrderStatus.delivered;
}