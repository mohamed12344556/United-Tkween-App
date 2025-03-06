import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../entities/profile_entity.dart';
import '../entities/library_item_entity.dart';
import '../entities/user_order_entity.dart';

abstract class ProfileRepository {
  // الملف الشخصي
  Future<Either<ApiErrorModel, ProfileEntity>> getProfile();
  Future<Either<ApiErrorModel, bool>> updateProfile(ProfileEntity profile);
  
  // المشتريات
  Future<Either<ApiErrorModel, List<UserOrderEntity>>> getUserOrders();
  Future<Either<ApiErrorModel, UserOrderEntity>> getOrderDetails(String orderId);
  
  // المكتبة
  Future<Either<ApiErrorModel, List<LibraryItemEntity>>> getLibraryItems();
  Future<Either<ApiErrorModel, LibraryItemEntity>> getLibraryItemDetails(String itemId);
  Future<Either<ApiErrorModel, String>> downloadLibraryItem(String itemId);
  
  // دعم المتجر
  Future<Either<ApiErrorModel, bool>> sendSupportMessage(String message);
}