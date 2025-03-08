import 'dart:async';

import '../../../../core/api/token_manager.dart';



abstract class AuthLocalDataSource {
  Future<void> saveAuthTokens({
    required String token,
    required String refreshToken,
  });
  Future<TokenPair?> getAuthTokens();
  Future<void> clearAuthTokens();
  Future<bool> hasValidTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> saveAuthTokens({
    required String token,
    required String refreshToken,
  }) async {
    await TokenManager.saveTokens(token: token, refreshToken: refreshToken);
  }

  @override
  Future<TokenPair?> getAuthTokens() async {
    return await TokenManager.getTokens();
  }

  @override
  Future<void> clearAuthTokens() async {
    await TokenManager.clearTokens();
  }

  @override
  Future<bool> hasValidTokens() async {
    return await TokenManager.hasValidTokens();
  }
}
