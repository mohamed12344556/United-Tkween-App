import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:united_formation_app/core/error/user_friendly_error_handler.dart';
import 'package:united_formation_app/features/auth/data/services/guest_mode_manager.dart';

import '../../../../core/core.dart';

class DeleteAccountService {
  final ApiService _apiService;

  DeleteAccountService({required ApiService apiService})
    : _apiService = apiService;

  /// حذف حساب المستخدم الحالي
  Future<Either<ApiErrorModel, bool>> deleteAccount() async {
    try {
      // التحقق مما إذا كان المستخدم في وضع الضيف
      final isGuestMode = await GuestModeManager.isGuestMode();
      if (isGuestMode) {
        return Left(
          ApiErrorModel(
            errorMessage: UserFriendlyErrorHandler.getDeleteAccountErrorMessage(
              'guest_mode',
            ),
          ),
        );
      }

      // استدعاء واجهة برمجة التطبيقات لحذف الحساب
      Map<String, dynamic> response = await _apiService.deleteAccount();

      // التحقق من استجابة الخادم
      if (response != null && response['status'] == 'success') {
        // تنظيف بيانات الجلسة بعد حذف الحساب
        await _cleanupAfterDeletion();
        return const Right(true);
      } else {
        final errorMessage = response['message'] ?? 'فشل في حذف الحساب';
        return Left(
          ApiErrorModel(
            errorMessage: UserFriendlyErrorHandler.getDeleteAccountErrorMessage(
              errorMessage,
            ),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        ApiErrorModel(
          errorMessage: UserFriendlyErrorHandler.getDeleteAccountErrorMessage(
            e,
          ),
        ),
      );
    } catch (e) {
      return Left(
        ApiErrorModel(
          errorMessage: UserFriendlyErrorHandler.getDeleteAccountErrorMessage(
            e.toString(),
          ),
        ),
      );
    }
  }

  /// تنظيف البيانات بعد حذف الحساب
  Future<void> _cleanupAfterDeletion() async {
    // حذف التوكن وبيانات الجلسة
    await TokenManager.clearTokens();
    await GuestModeManager.resetGuestMode();

    // إضافة أي تنظيف إضافي هنا إذا لزم الأمر
    // مثل مسح الذاكرة المؤقتة أو البيانات المحلية
  }
}
