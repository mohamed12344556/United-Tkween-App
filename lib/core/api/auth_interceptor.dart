import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core.dart';

class AuthInterceptor extends Interceptor {
  final bool shouldRefresh;

  AuthInterceptor({this.shouldRefresh = true});

  @override

  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final tokens = await TokenManager.getTokens();

    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';

      if (_isRefreshEndpoint(options.path)) {
        options.headers['Cookie'] = 'RefreshToken=${tokens.refreshToken}';
      }
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && shouldRefresh) {
      try {
        final result = await _handleTokenRefresh(err.requestOptions);
        return handler.resolve(result);
      } catch (e) {
        await _handleAuthError();
        return handler.reject(err);
      }
    }
    return handler.next(err);
  }

  Future<Response<dynamic>> _handleTokenRefresh(
      RequestOptions originalRequest) async {
    final tokens = await TokenManager.getTokens();
    if (tokens == null) {
      throw const AuthException('No tokens available for refresh');
    }

    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'RefreshToken=${tokens.refreshToken}',
      },
    ));

    final response = await dio.post(ApiConstants.refreshToken);

    if (response.statusCode == 200 && response.data['isSuccess'] == true) {
      final newToken = response.data['data']['token'];
      final newRefreshToken = response.data['data']['refreshToken'];

      await TokenManager.saveTokens(
        token: newToken,
        refreshToken: newRefreshToken,
      );

      originalRequest.headers['Authorization'] = 'Bearer $newToken';
      return dio.fetch(originalRequest);
    }

    throw const AuthException('Token refresh failed');
  }

  Future<void> _handleAuthError() async {
    await TokenManager.clearTokens();
    _redirectToLogin();
  }

  void _redirectToLogin() {
    final context = NavigationService.navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.loginView,
        (route) => false,
      );
    }
  }

  bool _isRefreshEndpoint(String path) {
    return path.contains('RefreshToken') || path.contains('RevokeToken');
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class TokenPair {
  final String token;
  final String refreshToken;

  TokenPair(this.token, this.refreshToken);
}

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
