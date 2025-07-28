class ApiConstants {
  static const String baseUrl = 'https://tkweenstore.com/api/';

  // API Endpoints
  static const String login = 'login.php';
  static const String register = 'register.php';
  static const String getOrders = 'get_orders.php';
  static const String getBooks = 'get_books.php';
  static const String getCategories = 'get_categories.php';
  static const String createPurchase = 'create_purchase.php';
  static const String createMultiplePurchase = 'create_multiple_purchases.php';
  static const String getProfile = 'getProfile.php';
  static const String updateProfile = 'update_profile.php';
  static const String fetchLibrary = 'fetch_library.php';
  static const String deleteAccount = 'delete_account.php';
  
  // لا توجد واجهة لتحديث كلمة المرور أو استعادتها في API تكوين الحالي
  // لذلك سنحتفظ بها للتوافق مع الكود الحالي
  static const String forgotPassword = 'forgot_password.php';
  static const String resetPassword = 'reset_password.php';
  static const String verifyResetPasswordOTP = 'verify_reset_password_otp.php';
  static const String verifyEmail = 'verify_email.php';
  static const String resendVerificationCode = 'resend_verification_code.php';
}