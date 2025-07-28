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

      // Now this will return CreatePurchaseResponse directly
      final response = await _apiService.createPurchase(requestBody);
      return response;
    } on DioException catch (e) {
      String errorMessage = _handleDioError(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('خطأ غير متوقع: $e');
    }
  }

  Future<CreatePurchaseResponse> createMultipleBooksPurchase({
    required List<String> bookIds,
    required List<int> quantities,
    required String fullName,
    required String email,
    required String phone,
    required String address,
    String paymentMethod = 'credit_card',
  }) async {
    try {
      final requestBody = {
        'book_ids': bookIds.map((id) => int.parse(id)).toList(),
        'quantities': quantities,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'payment_method': paymentMethod,
        'address': address,
      };

      // Now this will return CreatePurchaseResponse directly
      final response = await _apiService.createMultiplePurchase(requestBody);
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
  final double? amount;
  final String? bookType;
  final bool? isFree;
  final CustomerDetails? customerDetails;
  final String? paymentUrl;

  CreatePurchaseResponse({
    required this.success,
    required this.message,
    this.orderId,
    this.chargeId,
    this.bookTitle,
    this.amount,
    this.bookType,
    this.isFree,
    this.customerDetails,
    this.paymentUrl,
  });

  factory CreatePurchaseResponse.fromJson(Map<String, dynamic> json) {
    return CreatePurchaseResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      orderId: json['order_id'],
      chargeId: json['charge_id'],
      bookTitle: json['book_title'],
      amount: json['amount']?.toDouble(),
      bookType: json['book_type'],
      isFree: json['is_free'],
      customerDetails:
          json['customer_details'] != null
              ? CustomerDetails.fromJson(json['customer_details'])
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
      'amount': amount,
      'book_type': bookType,
      'is_free': isFree,
      'customer_details': customerDetails?.toJson(),
      'payment_url': paymentUrl,
    };
  }
}

class CustomerDetails {
  final String name;
  final String email;
  final String phone;

  CustomerDetails({
    required this.name,
    required this.email,
    required this.phone,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone};
  }
}
