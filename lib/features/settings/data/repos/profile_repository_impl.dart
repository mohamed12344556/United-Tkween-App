import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/settings/domain/entities/library_item_entity.dart';
import 'package:united_formation_app/features/settings/domain/entities/user_order_entity.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repos/profile_repository.dart';
import '../../../../core/core.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final Connectivity connectivity;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  // تحقق من توفر الإنترنت
  Future<bool> _isConnected() async {
    final result = await connectivity.checkConnectivity();
    return !(result.contains(ConnectivityResult.none) && result.length == 1);
  }

  @override
  Future<Either<ApiErrorModel, ProfileEntity>> getProfile() async {
    try {
      // محاولة جلب البيانات من الخادم أولاً إذا كان متصلاً بالإنترنت
      if (await _isConnected()) {
        print("Connected to internet, fetching profile from API");
        final remoteResult = await remoteDataSource.getProfile();

        return remoteResult.fold(
          (error) async {
            print("Error from API: ${error.errorMessage}");
            // في حالة الخطأ، جلب البيانات من التخزين المحلي (Hive)
            final localResult = await localDataSource.getCachedProfile();

            return localResult.fold((cacheError) {
              print("Error from cache: ${cacheError.errorMessage}");
              return Left(cacheError);
            }, (cachedProfile) {
              if (cachedProfile != null) {
                print("Returning cached profile: ${cachedProfile.fullName}");
                return Right(cachedProfile);
              } else {
                print("No cached profile found, returning original error");
                return Left(error);
              }
            });
          },
          (profile) async {
            print("Successfully got profile from API: ${profile.fullName}");
            // تخزين البيانات في التخزين المحلي (Hive)
            await localDataSource.cacheProfile(profile);
            print("Profile cached successfully");
            return Right(profile);
          },
        );
      } else {
        print("No internet connection, trying to get profile from cache");
        // في حالة عدم وجود إنترنت، جلب البيانات من التخزين المحلي (Hive)
        final localResult = await localDataSource.getCachedProfile();

        return localResult.fold((error) {
          print("Error getting profile from cache: ${error.errorMessage}");
          return Left(error);
        }, (cachedProfile) {
          if (cachedProfile != null) {
            print("Returning cached profile: ${cachedProfile.fullName}");
            return Right(cachedProfile);
          } else {
            print("No cached profile found");
            return Left(
              ApiErrorModel(
                errorMessage: 'لا يوجد اتصال بالإنترنت ولا توجد بيانات مخزنة',
              ),
            );
          }
        });
      }
    } catch (e) {
      print("Unexpected error in getProfile: $e");
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> updateProfile(
    ProfileEntity profile,
  ) async {
    try {
      if (await _isConnected()) {
        print("Connected to internet, updating profile on API");
        // تحويل الكيان إلى نموذج البيانات
        final profileModel = ProfileModel.fromEntity(profile);

        // تحديث البيانات على الخادم
        final remoteResult = await remoteDataSource.updateProfile(profileModel);

        return remoteResult.fold((error) {
          print("Error updating profile: ${error.errorMessage}");
          return Left(error);
        }, (success) async {
          if (success) {
            print("Profile updated on API, updating cache");
            // تحديث البيانات في التخزين المحلي (Hive)
            await localDataSource.cacheProfile(profileModel);
            print("Cache updated successfully");
          }
          return Right(success);
        });
      } else {
        print("No internet connection, can't update profile");
        // يمكن تخزين التغييرات محلياً والتزامن لاحقاً عند توفر الإنترنت
        // حالياً نعود بخطأ عدم وجود اتصال
        return Left(ApiErrorModel(errorMessage: 'لا يوجد اتصال بالإنترنت'));
      }
    } catch (e) {
      print("Unexpected error in updateProfile: $e");
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> removeProfileImage() async {
    try {
      if (await _isConnected()) {
        final remoteResult = await remoteDataSource.removeProfileImage();
        return remoteResult.fold(
          (error) => Left(error),
          (success) => Right(success),
        );
      } else {
        return Left(
          ApiErrorModel(
            errorMessage: 'لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقاً',
          ),
        );
      }
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<ApiErrorModel, String>> uploadProfileImage(File file) async {
    try {
      if (await _isConnected()) {
        final remoteResult = await remoteDataSource.uploadProfileImage(file);
        return remoteResult;
      } else {
        return Left(
          ApiErrorModel(
            errorMessage: 'لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقاً',
          ),
        );
      }
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<UserOrderEntity>>> getUserOrders() async {
    try {
      // محاولة جلب البيانات من الخادم أولاً
      if (await _isConnected()) {
        final remoteResult = await remoteDataSource.getUserOrders();

        return remoteResult.fold(
          (error) async {
            // في حالة الخطأ، جلب البيانات من التخزين المحلي
            final localResult = await localDataSource.getCachedOrders();

            return localResult.fold((cacheError) => Left(cacheError), (
              cachedOrders,
            ) {
              if (cachedOrders != null && cachedOrders.isNotEmpty) {
                return Right(cachedOrders);
              } else {
                return Left(error);
              }
            });
          },
          (orders) async {
            // تحويل إلى entities
            final entities = orders.map((o) => o.toEntity()).toList();
            // تخزين البيانات في التخزين المحلي
            await localDataSource.cacheOrders(entities);
            return Right(entities);
          },
        );
      } else {
        // في حالة عدم وجود إنترنت، جلب البيانات من التخزين المحلي
        final localResult = await localDataSource.getCachedOrders();

        return localResult.fold((error) => Left(error), (cachedOrders) {
          if (cachedOrders != null && cachedOrders.isNotEmpty) {
            return Right(cachedOrders);
          } else {
            return Left(
              ApiErrorModel(
                errorMessage: 'لا يوجد اتصال بالإنترنت ولا توجد بيانات مخزنة',
              ),
            );
          }
        });
      }
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<ApiErrorModel, UserOrderEntity>> getOrderDetails(
    String orderId,
  ) async {
    try {
      if (await _isConnected()) {
        final remoteResult = await remoteDataSource.getOrderDetails(orderId);

        return remoteResult.fold(
          (error) => Left(error),
          (orderDetails) => Right(orderDetails.toEntity()),
        );
      } else {
        // في حالة عدم وجود إنترنت، محاولة البحث في المشتريات المخزنة
        final localResult = await localDataSource.getCachedOrders();

        return localResult.fold((error) => Left(error), (cachedOrders) {
          if (cachedOrders != null && cachedOrders.isNotEmpty) {
            final order =
                cachedOrders.where((o) => o.id == orderId).firstOrNull;
            if (order != null) {
              return Right(order);
            }
          }

          return Left(
            ApiErrorModel(
              errorMessage: 'لا يوجد اتصال بالإنترنت ولا توجد بيانات مخزنة',
            ),
          );
        });
      }
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<ApiErrorModel, List<LibraryItemEntity>>>
  getLibraryItems() async {
    try {
      // محاولة جلب البيانات من الخادم أولاً
      if (await _isConnected()) {
        final remoteResult = await remoteDataSource.getLibraryItems();

        return remoteResult.fold(
          (error) async {
            // في حالة الخطأ، جلب البيانات من التخزين المحلي
            final localResult = await localDataSource.getCachedLibraryItems();

            return localResult.fold((cacheError) => Left(cacheError), (
              cachedItems,
            ) {
              if (cachedItems != null && cachedItems.isNotEmpty) {
                return Right(cachedItems);
              } else {
                return Left(error);
              }
            });
          },
          (items) async {
            // تخزين البيانات في التخزين المحلي
            await localDataSource.cacheLibraryItems(items);
            return Right(items);
          },
        );
      } else {
        // في حالة عدم وجود إنترنت، جلب البيانات من التخزين المحلي
        final localResult = await localDataSource.getCachedLibraryItems();

        return localResult.fold((error) => Left(error), (cachedItems) {
          if (cachedItems != null && cachedItems.isNotEmpty) {
            return Right(cachedItems);
          } else {
            return Left(
              ApiErrorModel(
                errorMessage: 'لا يوجد اتصال بالإنترنت ولا توجد بيانات مخزنة',
              ),
            );
          }
        });
      }
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<ApiErrorModel, LibraryItemEntity>> getLibraryItemDetails(
    String itemId,
  ) async {
    try {
      if (await _isConnected()) {
        final remoteResult = await remoteDataSource.getLibraryItemDetails(
          itemId,
        );

        return remoteResult.fold(
          (error) => Left(error),
          (itemDetails) => Right(itemDetails),
        );
      } else {
        // في حالة عدم وجود إنترنت، محاولة البحث في المكتبة المخزنة
        final localResult = await localDataSource.getCachedLibraryItems();

        return localResult.fold((error) => Left(error), (cachedItems) {
          if (cachedItems != null && cachedItems.isNotEmpty) {
            final item = cachedItems.where((i) => i.id == itemId).firstOrNull;
            if (item != null) {
              return Right(item);
            }
          }

          return Left(
            ApiErrorModel(
              errorMessage: 'لا يوجد اتصال بالإنترنت ولا توجد بيانات مخزنة',
            ),
          );
        });
      }
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<ApiErrorModel, String>> downloadLibraryItem(
    String itemId,
  ) async {
    try {
      if (await _isConnected()) {
        final remoteResult = await remoteDataSource.downloadLibraryItem(itemId);

        return remoteResult.fold(
          (error) => Left(error),
          (fileUrl) => Right(fileUrl),
        );
      } else {
        return Left(
          ApiErrorModel(
            errorMessage: 'لا يوجد اتصال بالإنترنت، يجب الاتصال للتحميل',
          ),
        );
      }
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> sendSupportMessage(String message) async {
    try {
      if (await _isConnected()) {
        final remoteResult = await remoteDataSource.sendSupportMessage(message);

        return remoteResult.fold(
          (error) => Left(error),
          (success) => Right(success),
        );
      } else {
        return Left(
          ApiErrorModel(
            errorMessage: 'لا يوجد اتصال بالإنترنت، يرجى المحاولة لاحقاً',
          ),
        );
      }
    } catch (e) {
      return Left(ApiErrorModel(errorMessage: 'حدث خطأ غير متوقع: $e'));
    }
  }
}