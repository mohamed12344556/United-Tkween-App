import 'dart:developer';

class StorageKeys {
  const StorageKeys._();

  // Auth Related
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String isLoggedIn = 'is_logged_in';

  // User Data
  static const String userData = 'user_data';
  static const String userSettings = 'user_settings';
  static const String userPreferences = 'user_preferences';
  String checkUserWannaRestPasswordOrSignup({
    required Map<String, dynamic> args,
  }) {
    if (args['isRegistered'] == false) {
      log('user is not registered');
      return "${args["email"]}";
    } else {
      log('user is registered');
      return "${args["value"]}";
    }
  }
}
