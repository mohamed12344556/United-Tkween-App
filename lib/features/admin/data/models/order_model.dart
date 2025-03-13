import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  processing,
  completed,
  cancelled;

  String get arabicName {
    switch (this) {
      case OrderStatus.pending:
        return 'معلقة';
      case OrderStatus.processing:
        return 'قيد المعالجة';
      case OrderStatus.completed:
        return 'مكتملة';
      case OrderStatus.cancelled:
        return 'ملغية';
    }
  }
}

class OrderModel extends Equatable {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<OrderItem> items;
  final OrderStatus status;
  final DateTime date;
  final double total;

  const OrderModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.status,
    required this.date,
    required this.total,
  });

  @override
  List<Object?> get props => [
        id,
        customerName,
        customerPhone,
        customerAddress,
        items,
        status,
        date,
        total,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.name,
      'date': date.toIso8601String(),
      'total': total,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      date: DateTime.parse(json['date']),
      total: json['total'],
    );
  }
}

class OrderItem extends Equatable {
  final String productId;
  final String productName;
  final String? productCategory;
  final int quantity;
  final double price;

  const OrderItem({
    required this.productId,
    required this.productName,
    this.productCategory,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [
        productId,
        productName,
        productCategory,
        quantity,
        price,
      ];

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productCategory': productCategory,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      productCategory: json['productCategory'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}