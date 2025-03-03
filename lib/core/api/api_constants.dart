class ApiConstants {
  static const String baseUrl = 'http://eol.runasp.net';
  
  // API Endpoints
  static const String login = '/api/Account/Login';
  static const String signup = '/api/Account/SignUp';
  static const String refreshToken = '/api/Account/RefreshToken';
  static const String forgotPassword = '/api/Account/ForgotPassword';
  static const String resetPassword = '/api/Account/ResetPassword';
  static const String verifyResetPasswordOTP = '/api/Account/VerifyResetPasswordOTP';
  static const String revokeToken = '/api/Account/RevokeToken';
  static const String verifyEmail = '/api/Account/VerifyEmail';
  static const String resendVerificationCode = '/api/Account/ResendVerificationCode';

  // User Profile Endpoints
  static const String getUserProfile = '/api/Profile/GetUserProfile';
  static const String editUserProfile = '/api/Profile/EditUserProfile';
}