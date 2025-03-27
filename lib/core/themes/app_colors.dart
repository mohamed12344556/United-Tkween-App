// import 'package:flutter/material.dart';

// class AppColors {
//   //Private constructor to prevent instantiation
//   AppColors._();

//   static const Color primaryYellow = Color(0xFFFFD700);
//   static const Color lightGrey = Color(0xFF2E2E2E);
//   static const Color textColorWhite = Colors.white;
//   static const Color darkBackgroundColor = Color(0xFF1C1B1B);

//   // الألوان الأساسية من التصميم الجديد
//   // static const Color primary = Color(0xFFd1f362);
//   static const Color primary = Color(0xFFa8d032);

//   static const Color secondary = Color(
//     0xFF111111,
//   ); // اللون الأسود للأزرار الثانوية والنصوص
//   static const Color background = Color(0xFFFFFFFF); // خلفية بيضاء
//   static const Color accent = Color(0xFF4CAF50); // لون تأكيد أخضر (نحتفظ به)

//   // ألوان النص
//   static const Color text = Color(0xFF111111); // لون نص أسود غامق
//   static const Color textSecondary = Color(0xFF666666); // لون نص ثانوي
//   static const Color textHint = Color(0xFFBDBDBD); // لون نص إرشادي خافت

//   // ألوان الإشعارات والحالات
//   static const Color success = Color(0xFF4CAF50); // لون النجاح (أخضر)
//   static const Color info = Color(0xFF2196F3); // لون المعلومات (أزرق)
//   static const Color warning = Color(0xFFFFC107); // لون التحذير (أصفر)
//   static const Color error = Color(0xFFE53935); // لون الخطأ (أحمر)

//   // ألوان الوضع الداكن
//   static const Color darkBackground = Color(
//     0xFF111111,
//   ); // خلفية الوضع الداكن (أسود)
//   static const Color darkSurface = Color(0xFF1E1E1E); // سطح الوضع الداكن
//   static const Color darkSecondary = Color(
//     0xFF2C2C2C,
//   ); // لون ثانوي للوضع الداكن

//   // ألوان الحقول والمدخلات
//   static const Color inputBackground = Color(
//     0xFFFFFFFF,
//   ); // خلفية حقول الإدخال (أبيض)
//   static const Color inputBackgroundDark = Color(
//     0xFF2a2a28,
//   ); // خلفية حقول الإدخال (أبيض)
//   static const Color inputBorder = Color(
//     0xFFEEEEEE,
//   ); // حدود حقول الإدخال (رمادي فاتح)

//   // ألوان التفاعل
//   static const Color pressed = Color(0xFFE0E0E0); // لون العنصر عند الضغط
//   static const Color focused = Color(
//     0xFFE9F51D,
//   ); // لون العنصر عند التركيز (اللون الأصفر الأساسي)
//   static const Color disabled = Color(0xFFE0E0E0); // لون العنصر المعطل

//   // ألوان الحدود والفواصل
//   static const Color divider = Color(0xFFEEEEEE); // لون الفواصل
//   static const Color border = Color(0xFFE0E0E0); // لون الحدود

//   // ألوان التحديد
//   static const Color selectedChip = Color(
//     0xFFE9F51D,
//   ); // لون العنصر المحدد (أصفر ليموني)
//   static const Color unselectedChip = Color(
//     0xFFFFFFFF,
//   ); // لون العنصر غير المحدد (أبيض)

//   // درجات الشفافية
//   static const Color black38 = Colors.black38;
//   static const Color black12 = Colors.black12;
//   static const Color white70 = Colors.white70;
// }

import 'package:flutter/material.dart';

class AppColors {
  //Private constructor to prevent instantiation
  AppColors._();

  // Main colors from the Takween website
  static const Color primary = Color(
    0xFF851b6e,
  ); // Purple/magenta from the logo
  static const Color secondary = Color(
    0xFF009eb3,
  ); // Teal accent color from the tagline
  static const Color background = Colors.white; // White background
  static const Color buttonColor = Color(0xFFa67b9e); // Purple button color

  // Text colors
  static const Color text = Color(0xFF333333); // Dark text color
  static const Color textSecondary = Color(0xFF666666); // Secondary text color
  static const Color textHint = Color(0xFFBDBDBD); // Hint text color

  // UI colors
  static const Color lightGrey = Color(0xFFe9ecef); // Light grey background
  static const Color divider = Color(0xFFEEEEEE); // Divider color
  static const Color border = Color(0xFFE0E0E0); // Border color

  // Status colors
  static const Color success = Color(0xFF4CAF50); // Success color (green)
  static const Color info = Color(0xFF2196F3); // Info color (blue)
  static const Color warning = Color(0xFFFFC107); // Warning color (yellow)
  static const Color error = Color(0xFFE53935); // Error color (red)

  // Dark mode colors (if needed)
  static const Color darkBackground = Color(0xFF111111);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSecondary = Color(0xFF2C2C2C);

  // Input colors
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color inputBackgroundDark = Color(0xFF2a2a28);
  static const Color inputBorder = Color(0xFFEEEEEE);

  // Interaction colors
  static const Color pressed = Color(0xFFE0E0E0);
  static const Color focused = Color(
    0xFF851b6e,
  ); // Focus color matching primary
  static const Color disabled = Color(0xFFE0E0E0);

  // Selection colors
  static const Color selectedChip = Color(
    0xFF851b6e,
  ); // Selected chip using primary color
  static const Color unselectedChip = Colors.white;

  // Transparent colors
  static const Color black38 = Colors.black38;
  static const Color black12 = Colors.black12;
  static const Color white70 = Colors.white70;
}
