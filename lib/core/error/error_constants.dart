class ErrorConstants {
  const ErrorConstants._();

  // HTTP Errors
  static const String badRequest = 'Bad request error';
  static const String unauthorized = 'Unauthorized error';
  static const String forbidden = 'Forbidden error';
  static const String notFound = 'Not found error';
  static const String serverError = 'Internal server error';

  // Network Errors
  static const String noInternet = 'No internet connection';
  static const String timeout = 'Request timeout';
  static const String unknown = 'Unknown error occurred';

  // Auth Errors
  static const String invalidCredentials = 'Invalid email or password';
  static const String tokenExpired = 'Session expired, please login again';
  static const String invalidToken = 'Invalid authentication token';

  // Validation Errors
  static const String invalidEmail = 'Please enter a valid email';
  static const String invalidPassword =
      'Password must be at least 8 characters';
  static const String passwordMismatch = 'Passwords do not match';
  static const String requiredField = 'This field is required';
}