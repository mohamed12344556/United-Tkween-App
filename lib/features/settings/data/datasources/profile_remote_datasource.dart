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
  Future<Either<ApiErrorModel, String>> uploadProfileImage(File imagePath);
  Future<Either<ApiErrorModel, List<UserOrderModel>>> getUserOrders();
  Future<Either<ApiErrorModel, UserOrderModel>> getOrderDetails(String orderId);
  Future<Either<ApiErrorModel, List<LibraryItemModel>>> getLibraryItems();
  Future<Either<ApiErrorModel, LibraryItemModel>> getLibraryItemDetails(
    String itemId,
  );
  Future<Either<ApiErrorModel, String>> downloadLibraryItem(String itemId);
  Future<Either<ApiErrorModel, bool>> sendSupportMessage(String message);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<ApiErrorModel, ProfileModel>> getProfile() async {
    try {
      // استدعاء endpoint الخاصة بالحصول على معلومات المستخدم
      final response = await apiService.getProfile();

      // التأكد من صحة البيانات المستلمة
      if (response != null && response['status'] == 'success') {
        final userData = response['user'] ?? {};

        final profile = ProfileModel(
          id: userData['id']?.toString() ?? 'user-123',
          fullName: userData['full_name'] ?? userData['fullName'] ?? '',
          email: userData['email'] ?? '',
          phoneNumber1: userData['phone'] ?? userData['phoneNumber1'] ?? '',
          phoneNumber2: userData['phone2'] ?? userData['phoneNumber2'] ?? '',
          address: userData['address'] ?? '',
          profileImageUrl:
              userData['profile_image'] ?? userData['profileImageUrl'],
        );

        print("Profile loaded from API: ${profile.fullName}");
        return Right(profile);
      } else {
        print(
          "Error loading profile from API: ${response?['message'] ?? 'Unknown error'}",
        );
        return Left(
          ApiErrorModel(
            errorMessage: response?['message'] ?? 'فشل تحميل معلومات المستخدم',
          ),
        );
      }
    } catch (error) {
      print("Exception in getProfile: $error");
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> updateProfile(
    ProfileModel profile,
  ) async {
    try {
      // إعداد البيانات المطلوبة للتحديث
      final Map<String, dynamic> profileData = {
        'full_name': profile.fullName,
        'email': profile.email,
        'phone': profile.phoneNumber1,
        'address': profile.address,
      };

      if (profile.phoneNumber2 != null && profile.phoneNumber2!.isNotEmpty) {
        profileData['phone2'] = profile.phoneNumber2;
      }

      // استدعاء واجهة برمجة التطبيقات
      final response = await apiService.updateProfile(profileData);

      // تحليل الاستجابة
      if (response != null && response['status'] == 'success') {
        print("Profile updated successfully: ${response['message']}");
        return const Right(true);
      } else {
        print(
          "Failed to update profile: ${response?['message'] ?? 'Unknown error'}",
        );
        return Left(
          ApiErrorModel(
            errorMessage: response?['message'] ?? 'فشل تحديث الملف الشخصي',
          ),
        );
      }
    } catch (error) {
      print("Error in updateProfile: $error");
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<UserOrderModel>>> getUserOrders() async {
    try {
      final response = await apiService.getOrders();

      if (response != null && response['status'] == 'success') {
        final List<dynamic> ordersData = response['orders'] ?? [];

        final orders = ordersData.map((orderData) {
          return UserOrderModel.fromApiJson(orderData as Map<String, dynamic>);
        }).toList();

        return Right(orders);
      } else {
        return Left(
          ApiErrorModel(
            errorMessage: response?['message'] ?? 'فشل جلب الطلبات',
          ),
        );
      }
    } catch (error) {
      print("Error in getUserOrders: $error");
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, UserOrderModel>> getOrderDetails(
    String orderId,
  ) async {
    try {
      // لا توجد واجهة برمجة تطبيقات محددة للحصول على تفاصيل طلب معين
      // يمكن استرجاع جميع الطلبات والبحث عن الطلب المحدد

      final ordersResult = await getUserOrders();

      return ordersResult.fold((error) => Left(error), (orders) {
        final order = orders.firstWhere(
          (o) => o.id == orderId,
          orElse:
              () => UserOrderModel(
                id: orderId,
                statusString: 'PROCESSING',
                createdAt: DateTime.now(),
              ),
        );

        return Right(order);
      });
    } catch (error) {
      print("Error in getOrderDetails: $error");
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<LibraryItemModel>>>
  getLibraryItems() async {
    try {
      // استدعاء واجهة برمجة التطبيقات للحصول على عناصر المكتبة
      final response = await apiService.fetchLibrary();

      // تحليل الاستجابة
      if (response != null && response['status'] == 'success') {
        final List<dynamic> itemsData = response['library_items'] ?? [];

        // تحويل البيانات إلى نماذج
        final items =
            itemsData.map((itemData) {
              return LibraryItemModel(
                id: itemData['id'].toString(),
                title: itemData['title'] ?? '',
                description: itemData['description'],
                orderDate:
                    DateTime.tryParse(itemData['order_date'] ?? '') ??
                    DateTime.now(),
                typeString: itemData['type'] ?? 'pdf',
                price:
                    double.tryParse(itemData['price']?.toString() ?? '0') ??
                    0.0,
                thumbnailUrl: itemData['thumbnail_url'],
                fileUrl: itemData['file_url'],
                isDelivered:
                    itemData['is_delivered'] == true ||
                    itemData['is_delivered'] == 1,
              );
            }).toList();

        return Right(items);
      } else {
        return Left(
          ApiErrorModel(
            errorMessage: response?['message'] ?? 'فشل جلب عناصر المكتبة',
          ),
        );
      }
    } catch (error) {
      print("Error in getLibraryItems: $error");
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, LibraryItemModel>> getLibraryItemDetails(
    String itemId,
  ) async {
    try {
      // لا توجد واجهة برمجة تطبيقات محددة للحصول على تفاصيل عنصر مكتبة معين
      // يمكن استرجاع جميع العناصر والبحث عن العنصر المحدد

      final itemsResult = await getLibraryItems();

      return itemsResult.fold((error) => Left(error), (items) {
        final item = items.firstWhere(
          (i) => i.id == itemId,
          orElse:
              () => LibraryItemModel(
                id: itemId,
                title: 'غير معروف',
                orderDate: DateTime.now(),
                typeString: 'pdf',
                price: 0.0,
                isDelivered: false,
              ),
        );

        return Right(item);
      });
    } catch (error) {
      print("Error in getLibraryItemDetails: $error");
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, String>> downloadLibraryItem(
    String itemId,
  ) async {
    try {
      // الحصول على تفاصيل عنصر المكتبة أولاً
      final itemDetailsResult = await getLibraryItemDetails(itemId);

      return itemDetailsResult.fold((error) => Left(error), (item) {
        if (item.fileUrl != null && item.fileUrl!.isNotEmpty) {
          return Right(item.fileUrl!);
        } else {
          return Left(ApiErrorModel(errorMessage: 'لا يوجد ملف متاح للتنزيل'));
        }
      });
    } catch (error) {
      print("Error in downloadLibraryItem: $error");
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> sendSupportMessage(String message) async {
    try {
      // لا توجد واجهة برمجة تطبيقات محددة لإرسال رسائل الدعم
      // هنا نستخدم محاكاة لنجاح العملية

      await Future.delayed(const Duration(seconds: 1));
      return const Right(true);
    } catch (error) {
      print("Error in sendSupportMessage: $error");
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> removeProfileImage() async {
    try {
      // لا توجد واجهة برمجة تطبيقات محددة لإزالة صورة الملف الشخصي
      // هنا نستخدم محاكاة لنجاح العملية

      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(true);
    } catch (error) {
      print("Error in removeProfileImage: $error");
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, String>> uploadProfileImage(
    File imagePath,
  ) async {
    try {
      // لا توجد واجهة برمجة تطبيقات محددة لرفع صورة الملف الشخصي
      // هنا نستخدم محاكاة لعملية الرفع

      await Future.delayed(const Duration(seconds: 1));
      return const Right('https://example.com/profiles/default-avatar.jpg');
    } catch (error) {
      print("Error in uploadProfileImage: $error");
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
