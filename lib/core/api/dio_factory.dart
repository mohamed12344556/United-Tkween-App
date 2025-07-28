import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_constants.dart';
import 'auth_interceptor.dart';

class DioFactory {
  static Dio? dio;

  static Dio getDio() {
    if (dio == null) {
      dio = Dio();
      dio!.options.baseUrl = ApiConstants.baseUrl;
      dio!.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      dio!.interceptors.add(AuthInterceptor());

      dio!.interceptors.add(
        PrettyDioLogger(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }
    return dio!;
  }

  static void setTokenIntoHeader(String token) {
    dio?.options.headers['Authorization'] = 'Bearer $token';
  }

  static void removeTokenFromHeader() {
    dio?.options.headers.remove('Authorization');
  }
}