import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:united_formation_app/features/auth/data/models/login/login_model_request_body.dart';

import '../../../../core/api/dio_services.dart';
import '../../../../core/core.dart';

/// مدير وضع الضيف - يتعامل مع تخزين واسترجاع حالة الضيف
class GuestModeManager {
  static const String _isGuestModeKey = 'is_guest_mode';

  /// تحقق مما إذا كان المستخدم في وضع الضيف
  static Future<bool> isGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isGuestModeKey) ?? false;
  }

  /// تعيين وضع الضيف
  static Future<void> setGuestMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isGuestModeKey, value);
    debugPrint('Guest mode set to: $value');
  }

  /// إعادة تعيين وضع الضيف (عند تسجيل الخروج)
  static Future<void> resetGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isGuestModeKey, false);
    debugPrint('Guest mode reset');
  }

  /// التحقق مما إذا كان المستخدم مسجل دخول أو ضيف
  static Future<bool> isAuthenticated() async {
    final isGuest = await isGuestMode();
    // المستخدم غير مصادق عليه إذا كان في وضع الضيف
    return !isGuest;
  }

  /// تنفيذ إجراءات تسجيل الدخول كضيف
  // static Future<void> loginAsGuest() async {
  //   try {
  //     // حفظ حالة وضع الضيف
  //     await setGuestMode(true);

  //     // إعادة تعيين التوكن وحالة تسجيل الدخول
  //     await Prefs.setData(key: StorageKeys.isLoggedIn, value: true);
  //     await Prefs.setData(key: StorageKeys.accessToken, value: "guest_token");
  //   } catch (e) {
  //     debugPrint('Error logging in as guest: $e');
  //     rethrow;
  //   }
  // }

  static Future<void> loginAsGuest() async {
    try {
      // استخدام بيانات اعتماد الضيف
      final email = "guest@gmail.com";
      final password = "100100";

      // إنشاء نموذج طلب تسجيل الدخول
      final loginRequestModel = LoginRequestModel(
        email: email,
        password: password,
      );

      // الحصول على خدمة API للاتصال بالخادم
      final dio = DioFactory.getDio();
      final apiService = ApiService(dio);

      // تنفيذ طلب تسجيل الدخول
      final response = await apiService.login(loginRequestModel);

      // التأكد من أن الاستجابة ناجحة وتحتوي على token
      if (response.status == "success" && response.token!.isNotEmpty) {
        // حفظ الـ token في التخزين
        await TokenManager.saveTokens(token: response.token!);

        // تعيين حالة تسجيل الدخول
        await Prefs.setData(key: StorageKeys.isLoggedIn, value: true);

        // تعيين حالة وضع الضيف للتمييز لاحقًا
        await setGuestMode(true);

        debugPrint(
          'Logged in as guest successfully with token: ${response.token}',
        );
      } else {
        throw Exception('Failed to login as guest: Invalid response');
      }
    } catch (e) {
      debugPrint('Error logging in as guest: $e');
      rethrow;
    }
  }
}
