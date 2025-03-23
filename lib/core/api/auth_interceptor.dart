import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../core.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenManager.getTokens();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (_isTokenError(err)) {
      await _handleAuthError();
      return handler.reject(err);
    }
    return handler.next(err);
  }

  bool _isTokenError(DioException err) {
    // تحقق من رمز الحالة 401 (غير مصرح)
    if (err.response?.statusCode == 401) return true;
    
    // تحقق من رسالة الخطأ إذا كانت تحتوي على كلمات متعلقة بالتوكن
    if (err.response?.data is Map) {
      String message = (err.response?.data['message'] ?? '').toString().toLowerCase();
      if (message.contains('token') || 
          message.contains('توكن') || 
          message.contains('غير مصرح') ||
          message.contains('الهيدرز')) {
        return true;
      }
    }
    
    // تحقق من نص الخطأ العام
    String errorMessage = err.message?.toLowerCase() ?? '';
    if (errorMessage.contains('unauthorized') || 
        errorMessage.contains('token') || 
        errorMessage.contains('auth')) {
      return true;
    }
    
    return false;
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
        arguments: {'fresh_start': true}
      );
    }
  }
}

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}