// lib/features/auth/ui/widgets/guest_restriction_dialog.dart

import 'package:flutter/material.dart';
import 'package:united_formation_app/core/core.dart';

import '../../data/services/guest_mode_manager.dart';

/// مربع حوار يظهر عندما يحاول المستخدم الضيف استخدام ميزة مقيدة
class GuestRestrictionDialog {
  /// عرض مربع حوار الوظائف المقيدة
  static Future<void> show(BuildContext context, {String? feature}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'ميزة مقيدة',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outlined,
                  size: 50.r,
                  color: AppColors.primary,
                ),
                SizedBox(height: 16.h),
                Text(
                  feature != null 
                      ? 'ميزة "$feature" متاحة فقط للمستخدمين المسجلين.' 
                      : 'هذه الميزة متاحة فقط للمستخدمين المسجلين.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'يرجى تسجيل الدخول أو إنشاء حساب للاستمتاع بجميع مميزات التطبيق.',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إلغاء'),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.loginView,
                        (route) => false,
                      );
                    },
                    child: const Text('تسجيل الدخول'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// امتداد لسياق البناء للتحقق من قيود وضع الضيف
extension GuestModeExtension on BuildContext {
  /// التحقق من القيود في وضع الضيف وعرض مربع حوار إذا كان المستخدم ضيفًا
  Future<bool> checkGuestRestriction({String? featureName}) async {
    final isGuest = await GuestModeManager.isGuestMode();
    if (isGuest) {
      if (mounted) {
        GuestRestrictionDialog.show(this, feature: featureName);
      }
      return true; // المستخدم مقيد (ضيف)
    }
    return false; // المستخدم غير مقيد (مسجل الدخول)
  }
}