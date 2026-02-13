import 'package:dio/dio.dart';

import '../../../../core/core.dart';

class CreatePurchaseService {
  final ApiService _apiService;

  CreatePurchaseService({required ApiService apiService})
    : _apiService = apiService;

  Future<CreatePurchaseResponse> createPurchase({
    required String bookId,
    required String fullName,
    required String email,
    required String phone,
    required String address,
    String paymentMethod = 'credit_card',
  }) async {
    try {
      final requestBody = {
        'book_id': int.parse(bookId),
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'payment_method': paymentMethod,
        'address': address,
      };

      final response = await _apiService.createPurchase(requestBody);
      return response;
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('خطأ غير متوقع: $e');
    }
  }

  String _handleDioError(DioException e) {
    if (e.response?.data != null) {
      if (e.response!.data is Map<String, dynamic>) {
        return e.response!.data['message'] ?? 'خطأ في الشبكة';
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'انتهت مهلة الاتصال';
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة استقبال البيانات';
      case DioExceptionType.badResponse:
        return 'استجابة خاطئة من الخادم';
      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';
      default:
        return 'خطأ في الشبكة';
    }
  }
}

class CreatePurchaseResponse {
  final bool success;
  final String message;
  final int? orderId;
  final String? chargeId;
  final String? bookTitle;
  final String? bookType;
  final bool? isFree;
  final PriceDetails? priceDetails;
  final CustomerDetails? customerDetails;
  final String? paymentMethod;
  final List<AppliedTax>? appliedTaxes;
  final AppliedShipping? appliedShipping;
  final String? paymentUrl;

  CreatePurchaseResponse({
    required this.success,
    required this.message,
    this.orderId,
    this.chargeId,
    this.bookTitle,
    this.bookType,
    this.isFree,
    this.priceDetails,
    this.customerDetails,
    this.paymentMethod,
    this.appliedTaxes,
    this.appliedShipping,
    this.paymentUrl,
  });

  double? get amount => priceDetails?.total;

  factory CreatePurchaseResponse.fromJson(Map<String, dynamic> json) {
    return CreatePurchaseResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      orderId: json['order_id'],
      chargeId: json['charge_id'],
      bookTitle: json['book_title'],
      bookType: json['book_type'],
      isFree: json['is_free'],
      priceDetails:
          json['price_details'] != null
              ? PriceDetails.fromJson(json['price_details'])
              : null,
      customerDetails:
          json['customer_details'] != null
              ? CustomerDetails.fromJson(json['customer_details'])
              : null,
      paymentMethod: json['payment_method'],
      appliedTaxes:
          json['applied_taxes'] != null
              ? (json['applied_taxes'] as List)
                  .map((e) => AppliedTax.fromJson(e))
                  .toList()
              : null,
      appliedShipping:
          json['applied_shipping'] != null
              ? AppliedShipping.fromJson(json['applied_shipping'])
              : null,
      paymentUrl: json['payment_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'order_id': orderId,
      'charge_id': chargeId,
      'book_title': bookTitle,
      'book_type': bookType,
      'is_free': isFree,
      'price_details': priceDetails?.toJson(),
      'customer_details': customerDetails?.toJson(),
      'payment_method': paymentMethod,
      'applied_taxes': appliedTaxes?.map((e) => e.toJson()).toList(),
      'applied_shipping': appliedShipping?.toJson(),
      'payment_url': paymentUrl,
    };
  }
}

class PriceDetails {
  final double subtotal;
  final double taxAmount;
  final double shippingCost;
  final double total;

  PriceDetails({
    required this.subtotal,
    required this.taxAmount,
    required this.shippingCost,
    required this.total,
  });

  factory PriceDetails.fromJson(Map<String, dynamic> json) {
    return PriceDetails(
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      taxAmount: (json['tax_amount'] ?? 0).toDouble(),
      shippingCost: (json['shipping_cost'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'tax_amount': taxAmount,
      'shipping_cost': shippingCost,
      'total': total,
    };
  }
}

class CustomerDetails {
  final String name;
  final String email;
  final String phone;
  final String? address;

  CustomerDetails({
    required this.name,
    required this.email,
    required this.phone,
    this.address,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone, 'address': address};
  }
}

class AppliedTax {
  final String id;
  final String name;
  final String rate;
  final String type;
  final double amount;

  AppliedTax({
    required this.id,
    required this.name,
    required this.rate,
    required this.type,
    required this.amount,
  });

  factory AppliedTax.fromJson(Map<String, dynamic> json) {
    return AppliedTax(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      rate: json['rate']?.toString() ?? '0',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rate': rate,
      'type': type,
      'amount': amount,
    };
  }
}

class AppliedShipping {
  final String id;
  final String name;
  final double cost;
  final String type;

  AppliedShipping({
    required this.id,
    required this.name,
    required this.cost,
    required this.type,
  });

  factory AppliedShipping.fromJson(Map<String, dynamic> json) {
    return AppliedShipping(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      cost: (json['cost'] ?? 0).toDouble(),
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'cost': cost, 'type': type};
  }
}
