import 'package:equatable/equatable.dart';

enum OrderStatus {
  processing,
  shipped,
  delivered,
  cancelled,
}

class OrderBookItem extends Equatable {
  final String bookId;
  final String title;
  final double unitPrice;
  final int quantity;
  final double total;

  const OrderBookItem({
    required this.bookId,
    required this.title,
    required this.unitPrice,
    required this.quantity,
    required this.total,
  });

  @override
  List<Object?> get props => [bookId, title, unitPrice, quantity, total];
}

class OrderCustomer extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String address;

  const OrderCustomer({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  List<Object?> get props => [name, email, phone, address];
}

class OrderPayment extends Equatable {
  final String method;
  final String? lastFour;
  final String? tapChargeId;

  const OrderPayment({
    required this.method,
    this.lastFour,
    this.tapChargeId,
  });

  @override
  List<Object?> get props => [method, lastFour, tapChargeId];
}

class OrderPriceSummary extends Equatable {
  final double subtotal;
  final double taxAmount;
  final double shippingCost;
  final double total;

  const OrderPriceSummary({
    required this.subtotal,
    required this.taxAmount,
    required this.shippingCost,
    required this.total,
  });

  @override
  List<Object?> get props => [subtotal, taxAmount, shippingCost, total];
}

class OrderShipping extends Equatable {
  final String methodName;
  final double cost;

  const OrderShipping({
    required this.methodName,
    required this.cost,
  });

  @override
  List<Object?> get props => [methodName, cost];
}

class UserOrderEntity extends Equatable {
  final String id;
  final String? chargeId;
  final String title;
  final String? description;
  final DateTime orderDate;
  final OrderStatus status;
  final double price;
  final String? imageUrl;
  final List<OrderBookItem> books;
  final OrderCustomer? customer;
  final OrderPayment? payment;
  final OrderPriceSummary? priceSummary;
  final OrderShipping? shipping;
  final String? shippingAddress;

  const UserOrderEntity({
    required this.id,
    this.chargeId,
    required this.title,
    this.description,
    required this.orderDate,
    required this.status,
    required this.price,
    this.imageUrl,
    this.books = const [],
    this.customer,
    this.payment,
    this.priceSummary,
    this.shipping,
    this.shippingAddress,
  });

  @override
  List<Object?> get props => [
    id,
    chargeId,
    title,
    description,
    orderDate,
    status,
    price,
    imageUrl,
    books,
    customer,
    payment,
    priceSummary,
    shipping,
    shippingAddress,
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

  String get booksTitle {
    if (books.isEmpty) return title;
    if (books.length == 1) return books.first.title;
    return '${books.first.title} +${books.length - 1}';
  }
}