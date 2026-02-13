import 'dart:convert';
import 'package:hive_ce/hive.dart';
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

  // New fields for full order details
  @HiveField(7)
  final String? chargeId;

  @HiveField(8)
  final String? booksJson; // JSON encoded list of books

  @HiveField(9)
  final String? customerJson; // JSON encoded customer

  @HiveField(10)
  final String? paymentJson; // JSON encoded payment

  @HiveField(11)
  final String? priceSummaryJson; // JSON encoded price summary

  @HiveField(12)
  final String? shippingJson; // JSON encoded shipping

  @HiveField(13)
  final String? shippingAddress;

  OrderHiveModel({
    required this.id,
    required this.title,
    this.description,
    required this.orderDate,
    required this.statusString,
    required this.price,
    this.imageUrl,
    this.chargeId,
    this.booksJson,
    this.customerJson,
    this.paymentJson,
    this.priceSummaryJson,
    this.shippingJson,
    this.shippingAddress,
  });

  factory OrderHiveModel.fromUserOrderEntity(UserOrderEntity entity) {
    String statusToString(OrderStatus status) {
      switch (status) {
        case OrderStatus.processing: return 'processing';
        case OrderStatus.shipped: return 'shipped';
        case OrderStatus.delivered: return 'delivered';
        case OrderStatus.cancelled: return 'cancelled';
      }
    }

    // Encode books as JSON
    String? booksJson;
    if (entity.books.isNotEmpty) {
      booksJson = jsonEncode(entity.books.map((b) => {
        'bookId': b.bookId,
        'title': b.title,
        'unitPrice': b.unitPrice,
        'quantity': b.quantity,
        'total': b.total,
      }).toList());
    }

    // Encode customer as JSON
    String? customerJson;
    if (entity.customer != null) {
      customerJson = jsonEncode({
        'name': entity.customer!.name,
        'email': entity.customer!.email,
        'phone': entity.customer!.phone,
        'address': entity.customer!.address,
      });
    }

    // Encode payment as JSON
    String? paymentJson;
    if (entity.payment != null) {
      paymentJson = jsonEncode({
        'method': entity.payment!.method,
        'lastFour': entity.payment!.lastFour,
        'tapChargeId': entity.payment!.tapChargeId,
      });
    }

    // Encode price summary as JSON
    String? priceSummaryJson;
    if (entity.priceSummary != null) {
      priceSummaryJson = jsonEncode({
        'subtotal': entity.priceSummary!.subtotal,
        'taxAmount': entity.priceSummary!.taxAmount,
        'shippingCost': entity.priceSummary!.shippingCost,
        'total': entity.priceSummary!.total,
      });
    }

    // Encode shipping as JSON
    String? shippingJson;
    if (entity.shipping != null) {
      shippingJson = jsonEncode({
        'methodName': entity.shipping!.methodName,
        'cost': entity.shipping!.cost,
      });
    }

    return OrderHiveModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      orderDate: entity.orderDate,
      statusString: statusToString(entity.status),
      price: entity.price,
      imageUrl: entity.imageUrl,
      chargeId: entity.chargeId,
      booksJson: booksJson,
      customerJson: customerJson,
      paymentJson: paymentJson,
      priceSummaryJson: priceSummaryJson,
      shippingJson: shippingJson,
      shippingAddress: entity.shippingAddress,
    );
  }

  UserOrderEntity toUserOrderEntity() {
    OrderStatus stringToStatus(String statusString) {
      switch (statusString.toLowerCase()) {
        case 'processing':
        case 'initiated':
        case 'قيد المعالجة':
          return OrderStatus.processing;
        case 'shipped':
        case 'تم الشحن':
        case 'في الطريق':
          return OrderStatus.shipped;
        case 'delivered':
        case 'captured':
        case 'تم التوصيل':
          return OrderStatus.delivered;
        case 'cancelled':
        case 'failed':
        case 'ملغي':
          return OrderStatus.cancelled;
        default:
          return OrderStatus.processing;
      }
    }

    // Decode books
    List<OrderBookItem> books = [];
    if (booksJson != null) {
      final List<dynamic> booksData = jsonDecode(booksJson!);
      books = booksData.map((b) => OrderBookItem(
        bookId: b['bookId'] ?? '',
        title: b['title'] ?? '',
        unitPrice: (b['unitPrice'] ?? 0).toDouble(),
        quantity: b['quantity'] ?? 1,
        total: (b['total'] ?? 0).toDouble(),
      )).toList();
    }

    // Decode customer
    OrderCustomer? customer;
    if (customerJson != null) {
      final c = jsonDecode(customerJson!);
      customer = OrderCustomer(
        name: c['name'] ?? '',
        email: c['email'] ?? '',
        phone: c['phone'] ?? '',
        address: c['address'] ?? '',
      );
    }

    // Decode payment
    OrderPayment? payment;
    if (paymentJson != null) {
      final p = jsonDecode(paymentJson!);
      payment = OrderPayment(
        method: p['method'] ?? '',
        lastFour: p['lastFour'],
        tapChargeId: p['tapChargeId'],
      );
    }

    // Decode price summary
    OrderPriceSummary? priceSummary;
    if (priceSummaryJson != null) {
      final ps = jsonDecode(priceSummaryJson!);
      priceSummary = OrderPriceSummary(
        subtotal: (ps['subtotal'] ?? 0).toDouble(),
        taxAmount: (ps['taxAmount'] ?? 0).toDouble(),
        shippingCost: (ps['shippingCost'] ?? 0).toDouble(),
        total: (ps['total'] ?? 0).toDouble(),
      );
    }

    // Decode shipping
    OrderShipping? shipping;
    if (shippingJson != null) {
      final s = jsonDecode(shippingJson!);
      shipping = OrderShipping(
        methodName: s['methodName'] ?? '',
        cost: (s['cost'] ?? 0).toDouble(),
      );
    }

    return UserOrderEntity(
      id: id,
      chargeId: chargeId,
      title: title,
      description: description,
      orderDate: orderDate,
      status: stringToStatus(statusString),
      price: price,
      imageUrl: imageUrl,
      books: books,
      customer: customer,
      payment: payment,
      priceSummary: priceSummary,
      shipping: shipping,
      shippingAddress: shippingAddress,
    );
  }
}