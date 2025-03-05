import 'package:flutter/material.dart';

class AppColors {
  //Private constructor to prevent instantiation
  AppColors._();
  
  // الألوان الأساسية - نسخة محسنة
  static const Color primary = Color(0xFFFFD700); // لون ذهبي أكثر إشراقاً
  static const Color secondary = Color(0xFF3E3E3E); // لون ثانوي أعمق
  static const Color background = Color(0xFFF8F8F8); // خلفية فاتحة ناعمة
  static const Color accent = Color(0xFF4CAF50); // لون تأكيد أخضر

  // ألوان النص
  static const Color text = Color(0xFF212121); // لون نص أغمق وأكثر وضوحاً
  static const Color textSecondary = Color(0xFF757575); // لون نص ثانوي
  static const Color textHint = Color(0xFFBDBDBD); // لون نص إرشادي خافت

  // ألوان الإشعارات والحالات
  static const Color success = Color(0xFF4CAF50); // لون النجاح (أخضر)
  static const Color info = Color(0xFF2196F3); // لون المعلومات (أزرق)
  static const Color warning = Color(0xFFFFC107); // لون التحذير (أصفر)
  static const Color error = Color(0xFFE53935); // لون الخطأ (أحمر)

  // ألوان الوضع الداكن
  static const Color darkBackground = Color(0xFF121212); // خلفية الوضع الداكن
  static const Color darkSurface = Color(0xFF1E1E1E); // سطح الوضع الداكن
  static const Color darkSecondary = Color(
    0xFF2C2C2C,
  ); // لون ثانوي للوضع الداكن

  // ألوان التفاعل
  static const Color pressed = Color(0xFFE0E0E0); // لون العنصر عند الضغط
  static const Color focused = Color(0xFFE0F2F1); // لون العنصر عند التركيز
  static const Color disabled = Color(0xFFE0E0E0); // لون العنصر المعطل

  // ألوان الحدود والفواصل
  static const Color divider = Color(0xFFEEEEEE); // لون الفواصل
  static const Color border = Color(0xFFE0E0E0); // لون الحدود

  // درجات الشفافية
  static const Color black38 = Colors.black38;
  static const Color black12 = Colors.black12;
  static const Color white70 = Colors.white70;
}
