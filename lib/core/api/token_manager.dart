import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static Future<void> saveTokens({
    required String token,
    required String refreshToken,
  }) async {
    try {
      if (token.isEmpty || refreshToken.isEmpty) {
        throw const StorageException('Invalid tokens received');
      }

      await Future.wait(<Future<dynamic>>[
        _storage.write(key: StorageKeys.accessToken, value: token),
        _storage.write(key: StorageKeys.refreshToken, value: refreshToken),
        SharedPrefHelper.setData(StorageKeys.isLoggedIn, true),
      ]);

      AppState.isLoggedIn = true;
      DioFactory.setTokenIntoHeader(token);
    } catch (e) {
      throw StorageException('Failed to save tokens: $e');
    }
  }

  static Future<TokenPair?> getTokens() async {
    try {
      final token = await _storage.read(key: StorageKeys.accessToken);
      final refreshToken = await _storage.read(key: StorageKeys.refreshToken);

      if (token == null || refreshToken == null) return null;

      return TokenPair(accessToken: token);
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearTokens() async {
    try {
      await Future.wait(<Future<dynamic>>[
        _storage.delete(key: StorageKeys.accessToken),
        _storage.delete(key: StorageKeys.refreshToken),
        SharedPrefHelper.setData(StorageKeys.isLoggedIn, false),
      ]);
      AppState.isLoggedIn = false;
      DioFactory.removeTokenFromHeader();
    } catch (e) {
      throw StorageException('Failed to clear tokens: $e');
    }
  }

  static bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final data = json.decode(decoded);

      if (!data.containsKey('exp')) return true;

      final expiry = DateTime.fromMillisecondsSinceEpoch(data['exp'] * 1000);
      return DateTime.now().isAfter(expiry);
    } catch (e) {
      return true;
    }
  }

  static Future<bool> hasValidTokens() async {
    try {
      final tokens = await getTokens();
      if (tokens == null) {
        AppState.isLoggedIn = false;
        await SharedPrefHelper.setData(StorageKeys.isLoggedIn, false);
        return false;
      }

      final isValid = !isTokenExpired(tokens.accessToken);
      AppState.isLoggedIn = isValid;
      await SharedPrefHelper.setData(StorageKeys.isLoggedIn, isValid);
      return isValid;
    } catch (e) {
      AppState.isLoggedIn = false;
      await SharedPrefHelper.setData(StorageKeys.isLoggedIn, false);
      return false;
    }
  }
}

class TokenPair {
  final String accessToken;

  const TokenPair({required this.accessToken});
}

class StorageException implements Exception {
  final String message;
  const StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
