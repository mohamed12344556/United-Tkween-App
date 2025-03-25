import 'package:dio/dio.dart';

/// فئة لتحويل رسائل الخطأ التقنية إلى رسائل مفهومة للمستخدم
class UserFriendlyErrorHandler {
  // رسائل الخطأ الافتراضية
  static const String _defaultNetworkError = 'حدث خطأ في الاتصال بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى';
  static const String _defaultServerError = 'حدث خطأ في الخادم، يرجى المحاولة لاحقاً';
  static const String _defaultUnknownError = 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى';
  static const String _defaultTimeoutError = 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
  static const String _defaultAuthError = 'فشل في المصادقة، يرجى تسجيل الدخول مرة أخرى';
  
  // رسائل خاصة بحذف الحساب
  static const String _deleteAccountNetworkError = 'تعذر حذف الحساب بسبب مشكلة في الاتصال، يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى';
  static const String _deleteAccountServerError = 'تعذر حذف الحساب بسبب مشكلة في الخادم، يرجى المحاولة لاحقاً';
  static const String _deleteAccountUnknownError = 'تعذر حذف الحساب لسبب غير معروف، يرجى المحاولة مرة أخرى أو التواصل مع الدعم الفني';
  static const String _deleteAccountAuthError = 'تعذر حذف الحساب بسبب مشكلة في المصادقة، يرجى تسجيل الدخول مرة أخرى';
  static const String _deleteAccountGuestModeError = 'لا يمكن حذف الحساب في وضع الضيف';

  /// تحويل رسالة خطأ تقنية إلى رسالة صديقة للمستخدم لعملية حذف الحساب
  static String getDeleteAccountErrorMessage(dynamic error) {
    if (error is String) {
      if (error.contains('guest')) {
        return _deleteAccountGuestModeError;
      }
      
      // تحقق من رسائل الخطأ النصية الشائعة
      if (_isNetworkError(error)) {
        return _deleteAccountNetworkError;
      } else if (_isAuthError(error)) {
        return _deleteAccountAuthError;
      } else if (_isServerError(error)) {
        return _deleteAccountServerError;
      }
    } else if (error is DioException) {
      return _handleDioError(error, isDeleteAccount: true);
    }
    
    return _deleteAccountUnknownError;
  }

  /// تحويل رسالة خطأ تقنية عامة إلى رسالة صديقة للمستخدم
  static String getErrorMessage(dynamic error) {
    if (error is String) {
      // تحقق من رسائل الخطأ النصية الشائعة
      if (_isNetworkError(error)) {
        return _defaultNetworkError;
      } else if (_isAuthError(error)) {
        return _defaultAuthError;
      } else if (_isServerError(error)) {
        return _defaultServerError;
      }
      
      // إذا كانت الرسالة قصيرة ومفهومة (أقل من 50 حرف)، أعدها كما هي
      if (error.length < 50 && !_containsTechnicalTerms(error)) {
        return error;
      }
    } else if (error is DioException) {
      return _handleDioError(error, isDeleteAccount: false);
    }
    
    return _defaultUnknownError;
  }

  /// معالجة أخطاء Dio
  static String _handleDioError(DioException error, {bool isDeleteAccount = false}) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return isDeleteAccount ? _deleteAccountNetworkError : _defaultNetworkError;
      case DioExceptionType.badResponse:
        // تحقق من رمز الحالة للحصول على رسالة أكثر تحديدًا
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (statusCode == 401 || statusCode == 403) {
            return isDeleteAccount ? _deleteAccountAuthError : _defaultAuthError;
          } else if (statusCode >= 500) {
            return isDeleteAccount ? _deleteAccountServerError : _defaultServerError;
          }
        }
        // محاولة استخراج رسالة الخطأ من الاستجابة إذا كانت موجودة
        final errorMessage = _extractErrorMessage(error.response?.data);
        if (errorMessage != null && errorMessage.isNotEmpty) {
          return errorMessage;
        }
        break;
      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';
      default:
        break;
    }
    
    return isDeleteAccount ? _deleteAccountUnknownError : _defaultUnknownError;
  }

  /// استخراج رسالة الخطأ من استجابة الخادم
  static String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    
    try {
      if (data is Map<String, dynamic>) {
        // البحث عن حقول الرسائل الشائعة
        final possibleKeys = ['message', 'error', 'error_message', 'errorMessage'];
        for (final key in possibleKeys) {
          if (data.containsKey(key) && data[key] is String) {
            final message = data[key] as String;
            // التحقق من أن الرسالة ليست تقنية للغاية
            if (!_containsTechnicalTerms(message) && message.length < 100) {
              return message;
            }
          }
        }
      }
    } catch (e) {
      // تجاهل أي استثناءات أثناء استخراج الرسالة
    }
    
    return null;
  }

  /// تحقق مما إذا كانت الرسالة تحتوي على خطأ شبكة
  static bool _isNetworkError(String error) {
    final networkTerms = [
      'network', 'connection', 'internet', 'timeout', 'connect',
      'شبكة', 'اتصال', 'إنترنت', 'مهلة', 'انقطاع'
    ];
    
    return _containsAnyTerm(error.toLowerCase(), networkTerms);
  }

  /// تحقق مما إذا كانت الرسالة تحتوي على خطأ مصادقة
  static bool _isAuthError(String error) {
    final authTerms = [
      'auth', 'token', 'login', 'credential', 'unauthorized', '401',
      'مصادقة', 'توكن', 'دخول', 'تسجيل', 'غير مصرح'
    ];
    
    return _containsAnyTerm(error.toLowerCase(), authTerms);
  }

  /// تحقق مما إذا كانت الرسالة تحتوي على خطأ خادم
  static bool _isServerError(String error) {
    final serverTerms = [
      'server', '500', 'internal', 'service', 'unavailable',
      'خادم', 'سيرفر', 'داخلي', 'خدمة', 'غير متاح'
    ];
    
    return _containsAnyTerm(error.toLowerCase(), serverTerms);
  }

  /// تحقق مما إذا كانت الرسالة تحتوي على مصطلحات تقنية
  static bool _containsTechnicalTerms(String message) {
    final technicalTerms = [
      'exception', 'null', 'undefined', 'stack', 'trace', 'error:',
      'syntax', 'dart:', 'flutter:', 'dio', 'http:', 'https:',
      'json', 'parse', 'format', 'index', 'range', 'type', 'assertion',
      'استثناء', 'خطأ تقني', 'فهرس', 'مدى', 'نوع', 'تأكيد'
    ];
    
    return _containsAnyTerm(message.toLowerCase(), technicalTerms);
  }

  /// تحقق مما إذا كانت النص يحتوي على أي من المصطلحات المحددة
  static bool _containsAnyTerm(String text, List<String> terms) {
    for (final term in terms) {
      if (text.contains(term)) {
        return true;
      }
    }
    return false;
  }
}