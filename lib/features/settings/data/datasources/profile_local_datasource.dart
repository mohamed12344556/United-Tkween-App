// lib/features/settings/data/datasources/profile_local_datasource.dart

import 'package:dartz/dartz.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:united_formation_app/features/settings/data/datasources/hive_models/library_hive_model.dart';
import 'package:united_formation_app/features/settings/data/datasources/hive_models/order_hive_model.dart';
import 'package:united_formation_app/features/settings/data/datasources/hive_models/profile_hive_model.dart';

import '../../../../core/core.dart';
import '../../domain/entities/user_order_entity.dart';
import '../models/library_item_model.dart';
import '../models/profile_model.dart';

/// أسماء صناديق Hive
class HiveBoxes {
  static const String profileBox = 'profile_box';
  static const String ordersBox = 'orders_box';
  static const String libraryBox = 'library_box';

  // مفاتيح لتخزين العناصر الفردية
  static const String profileKey = 'profile_data';
}

/// مصدر البيانات المحلي لوحدة الملف الشخصي
abstract class ProfileLocalDataSource {
  Future<Either<ApiErrorModel, ProfileModel?>> getCachedProfile();
  Future<Either<ApiErrorModel, bool>> cacheProfile(ProfileModel profile);

  Future<Either<ApiErrorModel, List<UserOrderEntity>?>> getCachedOrders();
  Future<Either<ApiErrorModel, bool>> cacheOrders(List<UserOrderEntity> orders);

  Future<Either<ApiErrorModel, List<LibraryItemModel>?>>
  getCachedLibraryItems();
  Future<Either<ApiErrorModel, bool>> cacheLibraryItems(
    List<LibraryItemModel> items,
  );

  Future<Either<ApiErrorModel, bool>> clearCache();
}

/// التنفيذ الفعلي لمصدر البيانات المحلي باستخدام Hive
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  // الحصول على صندوق Hive للملف الشخصي
  Future<Box<ProfileHiveModel>> _getProfileBox() async {
    if (!Hive.isBoxOpen(HiveBoxes.profileBox)) {
      return await Hive.openBox<ProfileHiveModel>(HiveBoxes.profileBox);
    }
    return Hive.box<ProfileHiveModel>(HiveBoxes.profileBox);
  }

  // الحصول على صندوق Hive للطلبات
  Future<Box<OrderHiveModel>> _getOrdersBox() async {
    if (!Hive.isBoxOpen(HiveBoxes.ordersBox)) {
      return await Hive.openBox<OrderHiveModel>(HiveBoxes.ordersBox);
    }
    return Hive.box<OrderHiveModel>(HiveBoxes.ordersBox);
  }

  // الحصول على صندوق Hive لعناصر المكتبة
  Future<Box<LibraryHiveModel>> _getLibraryBox() async {
    if (!Hive.isBoxOpen(HiveBoxes.libraryBox)) {
      return await Hive.openBox<LibraryHiveModel>(HiveBoxes.libraryBox);
    }
    return Hive.box<LibraryHiveModel>(HiveBoxes.libraryBox);
  }

  // تنفيذ جلب الملف الشخصي المخزن
  @override
  Future<Either<ApiErrorModel, ProfileModel?>> getCachedProfile() async {
    try {
      final box = await _getProfileBox();
      final profileData = box.get(HiveBoxes.profileKey);

      print("Retrieved profile from Hive: ${profileData?.fullName}"); // للتتبع

      if (profileData == null) {
        return const Right(null);
      }

      // تحويل نموذج Hive إلى نموذج الكيان ثم إلى نموذج البيانات
      final profileEntity = profileData.toProfileEntity();
      return Right(ProfileModel.fromEntity(profileEntity));
    } catch (error) {
      print("Error retrieving profile: $error"); // للتتبع
      return Left(ApiErrorHandler.handle(error));
    }
  }

  // تنفيذ تخزين الملف الشخصي
  @override
  Future<Either<ApiErrorModel, bool>> cacheProfile(ProfileModel profile) async {
    try {
      final box = await _getProfileBox();

      print("Caching profile to Hive: ${profile.fullName}"); // للتتبع

      // تحويل نموذج البيانات إلى نموذج Hive
      final profileHiveModel = ProfileHiveModel.fromProfileEntity(profile);

      // تخزين البيانات
      await box.put(HiveBoxes.profileKey, profileHiveModel);
      return const Right(true);
    } catch (error) {
      print("Error caching profile: $error"); // للتتبع
      return Left(ApiErrorHandler.handle(error));
    }
  }

  // تنفيذ جلب الطلبات المخزنة
  @override
  Future<Either<ApiErrorModel, List<UserOrderEntity>?>> getCachedOrders() async {
    try {
      final box = await _getOrdersBox();
      final ordersList = box.values.toList();

      print("Retrieved ${ordersList.length} orders from Hive"); // للتتبع

      if (ordersList.isEmpty) {
        return const Right(null);
      }

      // تحويل قائمة نماذج Hive إلى قائمة entities
      final orders =
          ordersList.map((orderHive) => orderHive.toUserOrderEntity()).toList();

      return Right(orders);
    } catch (error) {
      print("Error retrieving orders: $error"); // للتتبع
      return Left(ApiErrorHandler.handle(error));
    }
  }

  // تنفيذ تخزين الطلبات
  @override
  Future<Either<ApiErrorModel, bool>> cacheOrders(
    List<UserOrderEntity> orders,
  ) async {
    try {
      final box = await _getOrdersBox();

      print("Caching ${orders.length} orders to Hive"); // للتتبع

      // حذف البيانات القديمة
      await box.clear();

      // تحويل قائمة نماذج البيانات إلى قائمة نماذج Hive وتخزينها
      for (var order in orders) {
        final orderHiveModel = OrderHiveModel.fromUserOrderEntity(order);
        await box.add(orderHiveModel);
      }

      return const Right(true);
    } catch (error) {
      print("Error caching orders: $error"); // للتتبع
      return Left(ApiErrorHandler.handle(error));
    }
  }

  // تنفيذ جلب عناصر المكتبة المخزنة
  @override
  Future<Either<ApiErrorModel, List<LibraryItemModel>?>>
  getCachedLibraryItems() async {
    try {
      final box = await _getLibraryBox();
      final itemsList = box.values.toList();

      print("Retrieved ${itemsList.length} library items from Hive"); // للتتبع

      if (itemsList.isEmpty) {
        return const Right(null);
      }

      // تحويل قائمة نماذج Hive إلى قائمة نماذج البيانات
      final items =
          itemsList.map((itemHive) {
            final itemEntity = itemHive.toLibraryItemEntity();
            return LibraryItemModel.fromEntity(itemEntity);
          }).toList();

      return Right(items);
    } catch (error) {
      print("Error retrieving library items: $error"); // للتتبع
      return Left(ApiErrorHandler.handle(error));
    }
  }

  // تنفيذ تخزين عناصر المكتبة
  @override
  Future<Either<ApiErrorModel, bool>> cacheLibraryItems(
    List<LibraryItemModel> items,
  ) async {
    try {
      final box = await _getLibraryBox();

      print("Caching ${items.length} library items to Hive"); // للتتبع

      // حذف البيانات القديمة
      await box.clear();

      // تحويل قائمة نماذج البيانات إلى قائمة نماذج Hive وتخزينها
      for (var item in items) {
        final itemHiveModel = LibraryHiveModel.fromLibraryItemEntity(item);
        await box.add(itemHiveModel);
      }

      return const Right(true);
    } catch (error) {
      print("Error caching library items: $error"); // للتتبع
      return Left(ApiErrorHandler.handle(error));
    }
  }

  // تنفيذ مسح الذاكرة المؤقتة
  @override
  Future<Either<ApiErrorModel, bool>> clearCache() async {
    try {
      // حذف جميع البيانات من جميع الصناديق
      final profileBox = await _getProfileBox();
      final ordersBox = await _getOrdersBox();
      final libraryBox = await _getLibraryBox();

      await profileBox.clear();
      await ordersBox.clear();
      await libraryBox.clear();

      print("All cache cleared successfully"); // للتتبع

      return const Right(true);
    } catch (error) {
      print("Error clearing cache: $error"); // للتتبع
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
