import 'dart:developer';

import '../core.dart';

class AppState {
  static bool isLoggedIn = false;
  static String? currentLocale;
  static bool isDarkMode = false;

  const AppState._();

  static Future<void> initialize() async {
    try { 
      final loggedIn = await SharedPrefHelper.getBool(StorageKeys.isLoggedIn);
      final token = SharedPrefHelper.getSecuredString(StorageKeys.accessToken) as String?;
      isLoggedIn = loggedIn && (token?.isNotEmpty ?? false);
      log("AppState initialized - isLoggedIn: $isLoggedIn");
    } catch (e) {
      log("Error initializing AppState: $e");
      isLoggedIn = false;
    }
  }
}