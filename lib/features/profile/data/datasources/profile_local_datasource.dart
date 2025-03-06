import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/profile/data/models/profile_model.dart';
import 'package:united_formation_app/features/profile/data/models/library_item_model.dart';
import 'package:united_formation_app/features/profile/data/models/user_order_model.dart';

import '../../../../core/core.dart';

/// مفاتيح التخزين المحلي
class ProfileStorageKeys {
  static const String profile = 'profile_data';
  static const String orders = 'user_orders';
  static const String libraryItems = 'library_items';
}

/// مصدر البيانات المحلي لوحدة الملف الشخصي
abstract class ProfileLocalDataSource {
  Future<Either<ApiErrorModel, ProfileModel?>> getCachedProfile();
  Future<Either<ApiErrorModel, bool>> cacheProfile(ProfileModel profile);
  Future<Either<ApiErrorModel, List<UserOrderModel>?>> getCachedOrders();
  Future<Either<ApiErrorModel, bool>> cacheOrders(List<UserOrderModel> orders);
  Future<Either<ApiErrorModel, List<LibraryItemModel>?>> getCachedLibraryItems();
  Future<Either<ApiErrorModel, bool>> cacheLibraryItems(List<LibraryItemModel> items);
  Future<Either<ApiErrorModel, bool>> clearCache();
}

/// التنفيذ الفعلي لمصدر البيانات المحلي
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<Either<ApiErrorModel, ProfileModel?>> getCachedProfile() async {
    try {
      final jsonString = await SharedPrefHelper.getString(ProfileStorageKeys.profile);
      
      if (jsonString.isEmpty) {
        return const Right(null);
      }
      
      final profileMap = json.decode(jsonString) as Map<String, dynamic>;
      return Right(ProfileModel.fromJson(profileMap));
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> cacheProfile(ProfileModel profile) async {
    try {
      final profileJson = json.encode(profile.toJson());
      await SharedPrefHelper.setData(ProfileStorageKeys.profile, profileJson);
      return const Right(true);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<UserOrderModel>?>> getCachedOrders() async {
    try {
      final jsonString = await SharedPrefHelper.getString(ProfileStorageKeys.orders);
      
      if (jsonString.isEmpty) {
        return const Right(null);
      }
      
      final ordersListJson = json.decode(jsonString) as List;
      final ordersList = ordersListJson
          .map((item) => UserOrderModel.fromJson(item as Map<String, dynamic>))
          .toList();
      
      return Right(ordersList);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> cacheOrders(List<UserOrderModel> orders) async {
    try {
      final ordersJson = json.encode(orders.map((e) => e.toJson()).toList());
      await SharedPrefHelper.setData(ProfileStorageKeys.orders, ordersJson);
      return const Right(true);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<LibraryItemModel>?>> getCachedLibraryItems() async {
    try {
      final jsonString = await SharedPrefHelper.getString(ProfileStorageKeys.libraryItems);
      
      if (jsonString.isEmpty) {
        return const Right(null);
      }
      
      final itemsListJson = json.decode(jsonString) as List;
      final itemsList = itemsListJson
          .map((item) => LibraryItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
      
      return Right(itemsList);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> cacheLibraryItems(List<LibraryItemModel> items) async {
    try {
      final itemsJson = json.encode(items.map((e) => e.toJson()).toList());
      await SharedPrefHelper.setData(ProfileStorageKeys.libraryItems, itemsJson);
      return const Right(true);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> clearCache() async {
    try {
      await SharedPrefHelper.removeData(ProfileStorageKeys.profile);
      await SharedPrefHelper.removeData(ProfileStorageKeys.orders);
      await SharedPrefHelper.removeData(ProfileStorageKeys.libraryItems);
      return const Right(true);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }
}