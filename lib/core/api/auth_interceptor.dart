import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenManager.getTokens();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _handleAuthError();
      return handler.reject(err);
    }
    return handler.next(err);
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
}

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}