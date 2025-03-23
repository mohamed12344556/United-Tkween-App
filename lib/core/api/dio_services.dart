import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cache/shared_pref_helper.dart';
import '../utilities/storage_keys.dart';



class DioService {
  final Dio _dio;

  DioService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.apiBaseUrl,
          connectTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
          headers: {"Content-Type": "application/json"},
        ),
      ){
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          String? userToken = getToken();
          String language = getCurrentLanguage();

          options.headers.addAll({
            "Authorization": "Bearer $userToken",
            "Accept": "application/json",
            "locale": language,
          });

          log("✅ Headers Added from Interceptor: ${options.headers}");

          return handler.next(options); // continue
        },
        onError: (error, handler) {
          log("❌ Dio Error: $error");
          return handler.next(error);
        },
        onResponse: (response, handler) {
          log("✅ Dio Response: ${response.statusCode}");
          return handler.next(response);
        },
      ),
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    ]);
  }


  String getCurrentLanguage() {
    return Prefs.getData(key: 'language') ?? 'en';
  }

  String? getToken() {
    return  Prefs.getData(key:StorageKeys.accessToken);
  }

  Future<Response> getRequest(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    return _dio.get(
      endpoint,
      queryParameters: queryParams,
      options: Options(
        headers:headers,
      ),
    );
  }

  Future<Response> postRequest(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    return _dio.post(
      endpoint,
      data: data,
      queryParameters: queryParams,
      options: Options(
        headers:headers,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
  }

  Future<Response> postRequestWithFormData(
    String endpoint,
    FormData formData, {
    Map<String, String>? headers,
  }) async {
    return _dio.post(
      endpoint,
      data: formData,
      options: Options(
        headers:headers,

        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
  }

  Future<Response> updateRequest(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    return _dio.put(
      endpoint,
      data: data,
      queryParameters: queryParams,
      options: Options(
        headers:headers,

      ),
    );
  }

  Future<Response> updateRequestWithFormData(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    return _dio.put(
      endpoint,
      data: data,
      queryParameters: queryParams,
      options: Options(
        headers:headers,

      ),
    );
  }
}

class ApiConstants {
  static const String apiBaseUrl = "https://tkweenstore.com/api/";

  static const String homeBooks = "get_books.php";
  static const String booksCategories = "get_categories.php";

}



class Prefs {
  static late SharedPreferences prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await prefs.setString(key, value);
    } else if (value is bool) {
      return await prefs.setBool(key, value);
    } else if (value is int) {
      return await prefs.setInt(key, value);
    } else if (value is double) {
      return await prefs.setDouble(key, value);
    }else if(value is List<String>){
      return await prefs.setStringList(key, value);
    }
    return false;
  }

  static dynamic getData({required String key}) {
    return prefs.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    await prefs.remove(key);
    return true;
  }

  static Future<bool> clearAllPrefs() async {
    await prefs.clear();
    return true;
  }
}

class Constants {
  Constants._();

  static const String fontRepubliko = 'Republiko';
  static const String isAlreadyLogin = 'isAlreadyLogin';
  static const String userToken = 'userToken';
  static const String isRemembered = 'isRemembered';
  static const String defaultChallengeImage = 'https://media.istockphoto.com/id/1266413326/vector/vector-challenge-sign-pop-art-comic-speech-bubble-with-expression-text-competition-bright.jpg?s=612x612&w=0&k=20&c=eYOQaCn7WvMAEo5ZxVHVVQ-pcNT8HZ-yPeTjueuXi28=';

}

