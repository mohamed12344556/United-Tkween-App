class ApiConstants {
  static const String baseUrl = 'https://tkweenstore.com/api/';

  // API Endpoints
  static const String login = 'login.php';
  static const String signup = 'signup.php';
  static const String logout = 'logout.php';
  static const String forgotPassword = 'forgot_password.php';
  static const String resetPassword = 'reset_password.php';
  static const String verifyResetPasswordOTP = 'verify_reset_password_otp.php';
  static const String verifyEmail = 'verify_email.php';
  static const String resendVerificationCode = 'resend_verification_code.php';
  static const String refreshToken = '/api/Account/RefreshToken';

  // Book Endpoints
  static const String getAllProducts = 'get_all_products.php';
  static const String getProductDetails = 'get_product_details.php';
  static const String addToCart = 'add_to_cart.php';
  static const String removeFromCart = 'remove_from_cart.php';
  static const String getCartItems = 'get_cart_items.php';
  static const String applyCoupon = 'apply_coupon.php';

  // Book Orders Endpoints
  static const String getOrders = 'get_orders.php';
  static const String getCategories = 'get_categories.php';

  // Payment Endpoints
  static const String makePayment = 'payment.php';

  // User Profile Endpoints
  static const String getUserProfile = 'get_user_profile.php';
  static const String updateUserProfile = 'update_user_profile.php';
  static const String updateUserPassword = 'update_user_password.php';
}
