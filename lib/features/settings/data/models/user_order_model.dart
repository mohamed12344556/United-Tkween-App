import '../../domain/entities/user_order_entity.dart';

class UserOrderModel {
  final String id;
  final String? chargeId;
  final String statusString;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<OrderBookItem> books;
  final OrderCustomer? customer;
  final OrderPayment? payment;
  final OrderPriceSummary? priceSummary;
  final OrderShipping? shipping;
  final String? shippingAddress;

  UserOrderModel({
    required this.id,
    this.chargeId,
    required this.statusString,
    required this.createdAt,
    this.updatedAt,
    this.books = const [],
    this.customer,
    this.payment,
    this.priceSummary,
    this.shipping,
    this.shippingAddress,
  });

  /// Parse from get_orders.php API response
  factory UserOrderModel.fromApiJson(Map<String, dynamic> json) {
    // Parse books
    final booksData = json['books'] as List<dynamic>? ?? [];
    final books = booksData.map((book) {
      return OrderBookItem(
        bookId: book['book_id']?.toString() ?? '',
        title: book['title'] ?? '',
        unitPrice: (book['unit_price'] ?? 0).toDouble(),
        quantity: book['quantity'] ?? 1,
        total: (book['total'] ?? 0).toDouble(),
      );
    }).toList();

    // Parse customer
    OrderCustomer? customer;
    if (json['customer'] != null) {
      final c = json['customer'];
      customer = OrderCustomer(
        name: c['name'] ?? '',
        email: c['email'] ?? '',
        phone: c['phone'] ?? '',
        address: c['address'] ?? '',
      );
    }

    // Parse payment
    OrderPayment? payment;
    if (json['payment'] != null) {
      final p = json['payment'];
      payment = OrderPayment(
        method: p['method'] ?? '',
        lastFour: p['last_four'],
        tapChargeId: p['tap_charge_id'],
      );
    }

    // Parse price_summary
    OrderPriceSummary? priceSummary;
    if (json['price_summary'] != null) {
      final ps = json['price_summary'];
      priceSummary = OrderPriceSummary(
        subtotal: (ps['subtotal'] ?? 0).toDouble(),
        taxAmount: (ps['tax_amount'] ?? 0).toDouble(),
        shippingCost: (ps['shipping_cost'] ?? 0).toDouble(),
        total: (ps['total'] ?? 0).toDouble(),
      );
    }

    // Parse shipping
    OrderShipping? shipping;
    if (json['shipping'] != null) {
      final s = json['shipping'];
      shipping = OrderShipping(
        methodName: s['method_name'] ?? '',
        cost: (s['cost'] ?? 0).toDouble(),
      );
    }

    return UserOrderModel(
      id: json['order_id']?.toString() ?? '',
      chargeId: json['charge_id'],
      statusString: json['status'] ?? 'INITIATED',
      createdAt:
          DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      books: books,
      customer: customer,
      payment: payment,
      priceSummary: priceSummary,
      shipping: shipping,
      shippingAddress: json['shipping_address'],
    );
  }

  UserOrderEntity toEntity() {
    // Build title from books
    String title;
    if (books.isEmpty) {
      title = 'طلب #$id';
    } else if (books.length == 1) {
      title = books.first.title;
    } else {
      title = '${books.first.title} +${books.length - 1}';
    }

    return UserOrderEntity(
      id: id,
      chargeId: chargeId,
      title: title,
      description: null,
      orderDate: createdAt,
      status: _mapStringToStatus(statusString),
      price: priceSummary?.total ?? 0.0,
      imageUrl: null,
      books: books,
      customer: customer,
      payment: payment,
      priceSummary: priceSummary,
      shipping: shipping,
      shippingAddress: shippingAddress,
    );
  }

  static OrderStatus _mapStringToStatus(String statusString) {
    switch (statusString.toUpperCase()) {
      case 'INITIATED':
      case 'PROCESSING':
      case 'قيد المعالجة':
        return OrderStatus.processing;
      case 'SHIPPED':
      case 'تم الشحن':
      case 'في الطريق':
        return OrderStatus.shipped;
      case 'DELIVERED':
      case 'CAPTURED':
      case 'تم التوصيل':
        return OrderStatus.delivered;
      case 'CANCELLED':
      case 'FAILED':
      case 'ملغي':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.processing;
    }
  }

  static String mapStatusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'PROCESSING';
      case OrderStatus.shipped:
        return 'SHIPPED';
      case OrderStatus.delivered:
        return 'DELIVERED';
      case OrderStatus.cancelled:
        return 'CANCELLED';
    }
  }
}