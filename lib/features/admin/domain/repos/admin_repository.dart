import 'package:dartz/dartz.dart';

import '../../../../core/error/api_error_model.dart';
import '../../data/models/order_model.dart';
import '../../data/models/product_model.dart';
import '../../data/models/support_message_model.dart';

abstract class AdminRepository {
  Future<Either<ApiErrorModel, List<OrderModel>>> getOrders();
  Future<Either<ApiErrorModel, OrderModel>> getOrderById(String id);
  Future<Either<ApiErrorModel, Unit>> updateOrderStatus(
      String orderId, OrderStatus status);

  Future<Either<ApiErrorModel, List<ProductModel>>> getProducts();
  Future<Either<ApiErrorModel, ProductModel>> getProductById(String id);
  Future<Either<ApiErrorModel, Unit>> addProduct(ProductModel product);
  Future<Either<ApiErrorModel, Unit>> updateProduct(ProductModel product);
  Future<Either<ApiErrorModel, Unit>> deleteProduct(String id);

  Future<Either<ApiErrorModel, List<SupportMessageModel>>> getSupportMessages();
  Future<Either<ApiErrorModel, Unit>> sendSupportMessage(String customerId, String message);
  Future<Either<ApiErrorModel, Unit>> markMessageAsRead(String messageId);
}
