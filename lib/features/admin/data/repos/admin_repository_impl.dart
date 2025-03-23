import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../domain/repos/admin_repository.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/support_message_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  // Mock data for development
  final List<OrderModel> _mockOrders = [
    OrderModel(
      id: '1001',
      customerName: 'أحمد محمد',
      customerPhone: '01234567890',
      customerAddress: 'شارع النصر، القاهرة',
      status: OrderStatus.pending,
      date: DateTime(2025, 1, 9),
      total: 110,
      items: [
        OrderItem(
          productId: '1',
          productName: 'كتاب التنمية البشرية',
          productCategory: 'كتب التنمية',
          quantity: 1,
          price: 50,
        ),
        OrderItem(
          productId: '2',
          productName: 'كتاب الأدب الحديث',
          productCategory: 'الكتب الأدبية',
          quantity: 2,
          price: 30,
        ),
      ],
    ),
    OrderModel(
      id: '1002',
      customerName: 'سارة أحمد',
      customerPhone: '01087654321',
      customerAddress: 'شارع الهرم، الجيزة',
      status: OrderStatus.processing,
      date: DateTime(2025, 1, 10),
      total: 120,
      items: [
        OrderItem(
          productId: '3',
          productName: 'كتاب علم النفس',
          productCategory: 'كتب علمية',
          quantity: 1,
          price: 120,
        ),
      ],
    ),
  ];

  final List<ProductModel> _mockProducts = [
    ProductModel(
      id: '1',
      name: 'كتاب التنمية البشرية',
      category: 'كتب التنمية',
      price: 50,
      quantity: 50,
      description: 'كتاب عن التنمية البشرية',
    ),
    ProductModel(
      id: '2',
      name: 'كتاب الأدب الحديث',
      category: 'الكتب الأدبية',
      price: 30,
      quantity: 200,
      description: 'كتاب عن الأدب الحديث',
    ),
    ProductModel(
      id: '3',
      name: 'كتاب علم النفس',
      category: 'كتب علمية',
      type: 'PDF',
      price: 40,
      quantity: 150,
      description: 'كتاب عن علم النفس',
    ),
  ];

  final List<SupportMessageModel> _mockSupportMessages = [
    SupportMessageModel(
      id: '1',
      customerName: 'أحمد محمد',
      message: 'مرحبا، لدي مشكلة في الطلب رقم 1001.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    SupportMessageModel(
      id: '2',
      customerName: 'سارة أحمد',
      message: 'هل يمكنني تغيير عنوان التسليم؟',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  @override
  Future<Either<ApiErrorModel, List<OrderModel>>> getOrders() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      return Right(_mockOrders);
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ أثناء جلب الطلبات'));
    }
  }

  @override
  Future<Either<ApiErrorModel, OrderModel>> getOrderById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final order = _mockOrders.firstWhere(
        (order) => order.id == id,
        orElse: () => throw Exception('Order not found'),
      );
      return Right(order);
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'لم يتم العثور على الطلب'));
    }
  }

  @override
  Future<Either<ApiErrorModel, Unit>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final orderIndex = _mockOrders.indexWhere((order) => order.id == orderId);
      if (orderIndex != -1) {
        // In a real implementation, this would update the backend
        // For now, just simulate success
        return const Right(unit);
      }
      throw Exception('Order not found');
    } catch (e) {
      return Left(
        ApiErrorModel(errorMessage: 'حدث خطأ أثناء تحديث حالة الطلب'),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, List<ProductModel>>> getProducts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Right(_mockProducts);
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ أثناء جلب المنتجات'));
    }
  }

  @override
  Future<Either<ApiErrorModel, ProductModel>> getProductById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final product = _mockProducts.firstWhere(
        (product) => product.id == id,
        orElse: () => throw Exception('Product not found'),
      );
      return Right(product);
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'لم يتم العثور على المنتج'));
    }
  }

  @override
  Future<Either<ApiErrorModel, Unit>> addProduct(ProductModel product) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // In a real implementation, this would add to the backend
      // For now, just simulate success
      return const Right(unit);
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ أثناء إضافة المنتج'));
    }
  }

  @override
  Future<Either<ApiErrorModel, Unit>> updateProduct(
    ProductModel product,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final productIndex = _mockProducts.indexWhere((p) => p.id == product.id);
      if (productIndex != -1) {
        // In a real implementation, this would update the backend
        // For now, just simulate success
        return const Right(unit);
      }
      throw Exception('Product not found');
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ أثناء تحديث المنتج'));
    }
  }

  @override
  Future<Either<ApiErrorModel, Unit>> deleteProduct(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final productIndex = _mockProducts.indexWhere((p) => p.id == id);
      if (productIndex != -1) {
        // In a real implementation, this would delete from the backend
        // For now, just simulate success
        return const Right(unit);
      }
      throw Exception('Product not found');
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ أثناء حذف المنتج'));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<SupportMessageModel>>>
  getSupportMessages() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Right(_mockSupportMessages);
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ أثناء جلب رسائل الدعم'));
    }
  }

  @override
  Future<Either<ApiErrorModel, Unit>> sendSupportMessage(
    String customerId,
    String message,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // In a real implementation, this would send to the backend
      // For now, just simulate success
      return const Right(unit);
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ أثناء إرسال الرسالة'));
    }
  }

  @override
  Future<Either<ApiErrorModel, Unit>> markMessageAsRead(
    String messageId,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final messageIndex = _mockSupportMessages.indexWhere(
        (msg) => msg.id == messageId,
      );
      if (messageIndex != -1) {
        // In a real implementation, this would update the backend
        // For now, just simulate success
        return const Right(unit);
      }
      throw Exception('Message not found');
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ أثناء تحديث الرسالة'));
    }
  }
}
