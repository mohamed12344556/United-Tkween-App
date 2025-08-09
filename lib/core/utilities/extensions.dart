import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:united_formation_app/features/settings/ui/widgets/delete_account_dialog.dart';
import '../../features/cart/data/models/cart_model.dart';
import '../../features/settings/domain/entities/user_order_entity.dart';
import '../../generated/l10n.dart';
import '../core.dart';
import '../../features/auth/data/services/guest_mode_manager.dart';

extension BuildContextExtensions on BuildContext {
  //! Get screen dimensions
  // // double get screenWidth => MediaQuery.of(this).size.width;
  // double get screenHeight => MediaQuery.of(this).size.height;
  double get paddingTop => MediaQuery.of(this).padding.top;

  double get paddingBottom => MediaQuery.of(this).padding.bottom;

  // double get paddingLeft => MediaQuery.of(this).padding.left;
  // double get paddingRight => MediaQuery.of(this).padding.right;

  //! Get screen orientation
  // bool get isPortrait =>
  //     MediaQuery.of(this).orientation == Orientation.portrait;

  //! get theme system
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  //! Localization
  S get localeS => S.of(this);

  //! Get Languages
  bool get isArabic {
    final locale = Localizations.localeOf(this);
    return locale.languageCode.toLowerCase() == 'ar';
  }

  bool get isEnglish {
    final locale = Localizations.localeOf(this);
    return locale.languageCode.toLowerCase() == 'en';
  }

  //! check if it under development
  bool get isDebug => kDebugMode;

  //! Navigation
  void navigateTo(String routeName) =>
      Navigator.pushReplacementNamed(this, routeName);

  Future<dynamic> navigateToNamed(String routeName) async {
    return Navigator.pushNamed(this, routeName);
  }

  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    required RoutePredicate predicate,
  }) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop() => Navigator.of(this).pop();

  //! Show SnackBar
  Future<T?> showSnackBarAsDialog<T>({
    required String message,
    required bool isError,
    required void Function()? onPressed,
  }) async {
    showDialog(
      context: this,
      builder:
          (_) => AlertDialog(
            icon:
                isError
                    ? const Icon(Icons.error, color: Colors.red, size: 32)
                    : const Icon(
                      Icons.check_circle_outline_outlined,
                      color: Colors.green,
                      size: 32,
                    ),
            content: Text(
              message,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isError ? Colors.red : Colors.green,
              ),
            ),
            actions: [
              TextButton(
                onPressed: onPressed,
                child: const Text(
                  'Got it',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
    );
    return null;
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Show success snackbar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Show loading dialog
  Future<void> showLoadingDialog() {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder:
          (context) => Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(32),
              child: const CircularProgressIndicator(),
            ),
          ),
    );
  }

  // Hide loading dialog
  void hideLoadingDialog() {
    Navigator.of(this).pop();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }

  // دالة معدلة لعرض تأكيد تسجيل الخروج مع دعم وضع الضيف
  Future<void> showLogoutConfirmation() async {
    // التحقق مما إذا كان المستخدم في وضع الضيف
    final isGuest = await GuestModeManager.isGuestMode();

    if (!mounted) return;

    return showDialog<void>(
      context: this,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            isGuest ? 'تسجيل الدخول' : 'تسجيل الخروج',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: Text(
            isGuest
                ? 'هل تريد الانتقال إلى صفحة تسجيل الدخول؟'
                : 'هل أنت متأكد من تسجيل الخروج؟',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('إلغاء'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isGuest ? AppColors.primary : AppColors.error,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(isGuest ? 'تسجيل الدخول' : 'تسجيل الخروج'),
                    onPressed: () async {
                      if (isGuest) {
                        // إعادة تعيين وضع الضيف والانتقال إلى صفحة تسجيل الدخول
                        await GuestModeManager.resetGuestMode();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.loginView,
                          (route) => false,
                          arguments: {'fresh_start': true},
                        );
                      } else {
                        // تسجيل الخروج العادي
                        await TokenManager.clearTokens();
                        await GuestModeManager.resetGuestMode(); // إعادة تعيين وضع الضيف أيضًا
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(Routes.loginView);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // دالة معدلة لعرض ملف حذف الحساب مع دعم وضع الضيف
  Future<void> showDeleteAccountConfirmation() async {
    return showDialog<void>(
      context: this,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteAccountDialog();
      },
    );
  }

  // إضافة دالة لإظهار رسالة "الميزة قادمة قريبًا"
  Future<void> showComingSoonFeature({
    String title = 'قريبًا',
    String message = 'اصبر تاخد حاجة نضيفة ⚒️ ,قريبًا',
    IconData icon = Icons.upcoming_outlined,
  }) async {
    return showDialog<void>(
      context: this,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Icon(icon, size: 50, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('حسنًا'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

extension NullOrEmpty on String? {
  bool isNullOrEmpty() => this == null || this == "";
}

extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}

extension UrlFormatter on String {
  String get asFullImageUrl {
    const String baseUrl = 'https://tkweenstore.com/';
    String cleanedPath = replaceFirst(RegExp(r'^(\.\./)+'), '');
    return '$baseUrl$cleanedPath';
  }
}

// extension CartToOrderExtension on List<CartItemModel> {
//   UserOrderEntity toOrderEntity() {
//     return UserOrderEntity(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       title: "طلب ${length} منتجات",
//       description: "تحتوي على ${map((e) => e.bookName).join(', ')}",
//       orderDate: DateTime.now(),
//       status: OrderStatus.processing,
//       price: fold(0, (sum, item) => sum + (item.unitPrice * item.quantity)),
//       imageUrl: null,
//     );
//   }
// }

extension CartItemsToOrder on List<CartItemModel> {
  UserOrderEntity toOrderEntity({
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    required int totalAmount,
  }) {
    return UserOrderEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'طلب #${DateTime.now().millisecondsSinceEpoch}',
      description: '$length منتجات - $customerName - $customerPhone',
      orderDate: DateTime.now(),
      status: OrderStatus.processing,
      price: totalAmount.toDouble(),
      imageUrl: null,
    );
  }
}

extension UnderDevelopmentX on Widget {
  Widget underDevelopment({
    bool isActive = true,
    String message = '🚧 Under Development',
    Color backgroundColor = const Color(0xFFFF9800), // Orange color
    Color textColor = Colors.white,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    double opacity = 0.95,
    TextStyle? textStyle,
    CrossAxisAlignment alignment = CrossAxisAlignment.center,
    bool showBorder = true,
    Color borderColor = const Color(0xFFE65100), // Darker orange
  }) {
    if (!isActive) return this;

    return Stack(
      children: [
        this,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(opacity),
              border:
                  showBorder
                      ? Border(bottom: BorderSide(color: borderColor, width: 2))
                      : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: alignment,
              children: [
                Text(
                  message,
                  style:
                      textStyle ??
                      TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                if (message.length >
                    30) // Add some breathing space for long messages
                  const SizedBox(height: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Alternative method for corner badge style
  Widget underDevelopmentBadge({
    bool isActive = true,
    String message = '🚧',
    Color backgroundColor = const Color(0xFFFF5722),
    Color textColor = Colors.white,
    double size = 40,
    Alignment alignment = Alignment.topRight,
  }) {
    if (!isActive) return this;

    return Stack(
      children: [
        this,
        Positioned.fill(
          child: Align(
            alignment: alignment,
            child: Container(
              width: size,
              height: size,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: size * 0.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Animated version for more attention
  Widget underDevelopmentAnimated({
    bool isActive = true,
    String message = '🚧 Under Development',
    Color backgroundColor = const Color(0xFFFF9800),
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 2),
  }) {
    if (!isActive) return this;

    return Stack(
      children: [
        this,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.7, end: 1.0),
            duration: duration,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.9),
                    gradient: LinearGradient(
                      colors: [
                        backgroundColor.withOpacity(0.8),
                        backgroundColor.withOpacity(0.95),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: backgroundColor.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
