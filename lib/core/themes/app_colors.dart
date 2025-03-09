import 'package:flutter/material.dart';

class AppColors {
  //Private constructor to prevent instantiation
  AppColors._();
  
  // الألوان الأساسية من التصميم الجديد
  static const Color primary = Color(0xFFd1f362); // اللون الأصفر الليموني المشرق
  static const Color secondary = Color(0xFF111111); // اللون الأسود للأزرار الثانوية والنصوص
  static const Color background = Color(0xFFFFFFFF); // خلفية بيضاء
  static const Color accent = Color(0xFF4CAF50); // لون تأكيد أخضر (نحتفظ به)

  // ألوان النص
  static const Color text = Color(0xFF111111); // لون نص أسود غامق
  static const Color textSecondary = Color(0xFF666666); // لون نص ثانوي
  static const Color textHint = Color(0xFFBDBDBD); // لون نص إرشادي خافت

  // ألوان الإشعارات والحالات
  static const Color success = Color(0xFF4CAF50); // لون النجاح (أخضر)
  static const Color info = Color(0xFF2196F3); // لون المعلومات (أزرق)
  static const Color warning = Color(0xFFFFC107); // لون التحذير (أصفر)
  static const Color error = Color(0xFFE53935); // لون الخطأ (أحمر)

  // ألوان الوضع الداكن
  static const Color darkBackground = Color(0xFF111111); // خلفية الوضع الداكن (أسود)
  static const Color darkSurface = Color(0xFF1E1E1E); // سطح الوضع الداكن
  static const Color darkSecondary = Color(0xFF2C2C2C); // لون ثانوي للوضع الداكن

  // ألوان الحقول والمدخلات
  static const Color inputBackground = Color(0xFFFFFFFF); // خلفية حقول الإدخال (أبيض)
  static const Color inputBackgroundDark = Color(0xFF2a2a28); // خلفية حقول الإدخال (أبيض)
  static const Color inputBorder = Color(0xFFEEEEEE); // حدود حقول الإدخال (رمادي فاتح)

  // ألوان التفاعل
  static const Color pressed = Color(0xFFE0E0E0); // لون العنصر عند الضغط
  static const Color focused = Color(0xFFE9F51D); // لون العنصر عند التركيز (اللون الأصفر الأساسي)
  static const Color disabled = Color(0xFFE0E0E0); // لون العنصر المعطل

  // ألوان الحدود والفواصل
  static const Color divider = Color(0xFFEEEEEE); // لون الفواصل
  static const Color border = Color(0xFFE0E0E0); // لون الحدود

  // ألوان التحديد
  static const Color selectedChip = Color(0xFFE9F51D); // لون العنصر المحدد (أصفر ليموني)
  static const Color unselectedChip = Color(0xFFFFFFFF); // لون العنصر غير المحدد (أبيض)

  // درجات الشفافية
  static const Color black38 = Colors.black38;
  static const Color black12 = Colors.black12;
  static const Color white70 = Colors.white70;
}