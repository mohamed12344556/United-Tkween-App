import 'package:flutter/material.dart';
import 'package:united_formation_app/features/settings/ui/widgets/delete_account_dialog.dart';
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
        duration: const Duration(seconds: 3),
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
        duration: const Duration(seconds: 3),
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
