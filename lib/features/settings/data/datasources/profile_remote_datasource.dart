import 'dart:io';

import 'package:dartz/dartz.dart';
import '../models/library_item_model.dart';
import '../models/profile_model.dart';
import '../models/user_order_model.dart';

import '../../../../core/core.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<ApiErrorModel, ProfileModel>> getProfile();
  Future<Either<ApiErrorModel, bool>> updateProfile(ProfileModel profile);
  Future<Either<ApiErrorModel, bool>> removeProfileImage();
  Future<Either<ApiErrorModel, bool>> uploadProfileImage(File imagePath);
  Future<Either<ApiErrorModel, List<UserOrderModel>>> getUserOrders();
  Future<Either<ApiErrorModel, UserOrderModel>> getOrderDetails(String orderId);
  Future<Either<ApiErrorModel, List<LibraryItemModel>>> getLibraryItems();
  Future<Either<ApiErrorModel, LibraryItemModel>> getLibraryItemDetails(String itemId);
  Future<Either<ApiErrorModel, String>> downloadLibraryItem(String itemId);
  Future<Either<ApiErrorModel, bool>> sendSupportMessage(String message);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<ApiErrorModel, ProfileModel>> getProfile() async {
    try {
      // TODO: Implement actual API call
      // final response = await apiService.getUserProfile();
      
      // Mock successful response for now
      await Future.delayed(const Duration(seconds: 1));
      
      // Use mock data
      final mockProfile = ProfileModel(
        id: 'user-123',
        fullName: 'أحمد محمد',
        email: 'ahmed@example.com',
        phoneNumber1: '01234567890',
        phoneNumber2: '09876543210',
        address: 'شارع النصر، القاهرة',
        profileImageUrl: null,
      );
      
      return Right(mockProfile);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> updateProfile(ProfileModel profile) async {
    try {
      // TODO: Implement actual API call
      // final response = await apiService.updateUserProfile(profile);
      
      // Mock successful response for now
      await Future.delayed(const Duration(seconds: 1));
      
      return const Right(true);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<UserOrderModel>>> getUserOrders() async {
    try {
      // TODO: Implement actual API call
      // final response = await apiService.getUserOrders();
      
      // Mock successful response for now
      await Future.delayed(const Duration(seconds: 1));
      
      // Use mock data
      final mockOrders = [
        UserOrderModel(
          id: 'order-1',
          title: 'كتاب التنمية البشرية',
          description: 'كتاب شامل عن التنمية البشرية والتطوير الذاتي',
          orderDate: DateTime(2023, 10, 1),
          statusString: 'delivered',
          price: 50.0,
          imageUrl: null,
        ),
        UserOrderModel(
          id: 'order-2',
          title: 'كتاب الأدب الحديث',
          description: 'كتاب يستعرض أهم الأعمال الأدبية الحديثة والمعاصرة',
          orderDate: DateTime(2023, 10, 5),
          statusString: 'shipped',
          price: 70.0,
          imageUrl: null,
        ),
        UserOrderModel(
          id: 'order-3',
          title: 'كتاب علم النفس',
          description: 'مدخل إلى علم النفس ونظرياته المختلفة',
          orderDate: DateTime(2023, 10, 15),
          statusString: 'processing',
          price: 65.0,
          imageUrl: null,
        ),
      ];
      
      return Right(mockOrders);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, UserOrderModel>> getOrderDetails(String orderId) async {
    try {
      // TODO: Implement actual API call
      // final response = await apiService.getOrderDetails(orderId);
      
      // Mock successful response for now
      await Future.delayed(const Duration(seconds: 1));
      
      // Use mock data - here we just return a mock order
      final mockOrder = UserOrderModel(
        id: orderId,
        title: 'كتاب التنمية البشرية',
        description: 'كتاب شامل عن التنمية البشرية والتطوير الذاتي',
        orderDate: DateTime(2023, 10, 1),
        statusString: 'delivered',
        price: 50.0,
        imageUrl: null,
      );
      
      return Right(mockOrder);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<LibraryItemModel>>> getLibraryItems() async {
    try {
      // TODO: Implement actual API call
      // final response = await apiService.getLibraryItems();
      
      // Mock successful response for now
      await Future.delayed(const Duration(seconds: 1));
      
      // Use mock data
      final mockItems = [
        LibraryItemModel(
          id: 'lib-1',
          title: 'كتاب التنمية البشرية',
          description: 'كتاب شامل عن التنمية البشرية والتطوير الذاتي',
          orderDate: DateTime(2023, 10, 1),
          typeString: 'pdf',
          price: 50.0,
          thumbnailUrl: null,
          fileUrl: 'https://example.com/files/book1.pdf',
          isDelivered: true,
        ),
        LibraryItemModel(
          id: 'lib-2',
          title: 'كتاب الأدب الحديث',
          description: 'كتاب يستعرض أهم الأعمال الأدبية الحديثة والمعاصرة',
          orderDate: DateTime(2023, 10, 5),
          typeString: 'word',
          price: 70.0,
          thumbnailUrl: null,
          fileUrl: null,
          isDelivered: false,
        ),
        LibraryItemModel(
          id: 'lib-3',
          title: 'كتاب علم النفس',
          description: 'مدخل إلى علم النفس ونظرياته المختلفة',
          orderDate: DateTime(2023, 10, 15),
          typeString: 'pdf',
          price: 65.0,
          thumbnailUrl: null,
          fileUrl: null,
          isDelivered: false,
        ),
      ];
      
      return Right(mockItems);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, LibraryItemModel>> getLibraryItemDetails(String itemId) async {
    try {
      // TODO: Implement actual API call
      // final response = await apiService.getLibraryItemDetails(itemId);
      
      // Mock successful response for now
      await Future.delayed(const Duration(seconds: 1));
      
      // Use mock data - here we just return a mock item
      final mockItem = LibraryItemModel(
        id: itemId,
        title: 'كتاب التنمية البشرية',
        description: 'كتاب شامل عن التنمية البشرية والتطوير الذاتي',
        orderDate: DateTime(2023, 10, 1),
        typeString: 'pdf',
        price: 50.0,
        thumbnailUrl: null,
        fileUrl: 'https://example.com/files/book1.pdf',
        isDelivered: true,
      );
      
      return Right(mockItem);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, String>> downloadLibraryItem(String itemId) async {
    try {
      // TODO: Implement actual API call
      // final response = await apiService.downloadLibraryItem(itemId);
      
      // Mock successful response for now
      await Future.delayed(const Duration(seconds: 2));
      
      // Return a mock file URL
      return const Right('https://example.com/downloads/book1.pdf');
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> sendSupportMessage(String message) async {
    try {
      // TODO: Implement actual API call
      // final response = await apiService.sendSupportMessage(message);
      
      // Mock successful response for now
      await Future.delayed(const Duration(seconds: 1));
      
      return const Right(true);
    } catch (error) {
      return Left(ApiErrorHandler.handle(error));
    }
  }
  
  @override
  Future<Either<ApiErrorModel, bool>> removeProfileImage() {
    // TODO: implement removeProfileImage
    throw UnimplementedError();
  }
  
  @override
  Future<Either<ApiErrorModel, bool>> uploadProfileImage(File imagePath) {
    // TODO: implement uploadProfileImage
    throw UnimplementedError();
  }
}