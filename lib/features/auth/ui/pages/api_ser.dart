import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ApiService {
  final Dio _dio;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.apiBaseUrl,
          connectTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
          headers: {"Content-Type": "application/json"},
        ),
      );

  String getCurrentLanguage() {
    return Prefs.getData(key: 'language') ?? 'en';
  }

  String? getToken() {
    return Prefs.getData(key: Constants.userToken);
  }

  Future<Response> getRequest(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    String? userToken = getToken();
    String language = getCurrentLanguage();
    log("👌User Token $userToken");
    return _dio.get(
      endpoint,
      queryParameters: queryParams,
      options: Options(
        headers: {
          "Authorization": "Bearer $userToken",
          "Accept": "application/json",
          "locale": language,
          ...?headers,
        },
      ),
    );
  }

  Future<Response> postRequest(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    String? userToken = getToken();
    String language = getCurrentLanguage();
    log("👌User language $language");
    return _dio.post(
      endpoint,
      data: data,
      queryParameters: queryParams,
      options: Options(
        headers: {
          "Authorization": "Bearer $userToken",
          "Accept": "application/json",
          "locale": language,
          ...?headers,
        },
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
    String? userToken = getToken();
    String language = getCurrentLanguage();
    return _dio.post(
      endpoint,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          "Accept": "application/json",
          "Authorization": "Bearer $userToken",
          "locale": language,
          ...?headers,
        },
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
    String? userToken = getToken();
    String language = getCurrentLanguage();
    return _dio.put(
      endpoint,
      data: data,
      queryParameters: queryParams,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $userToken",
          "locale": language,
          ...?headers,
        },
      ),
    );
  }

  Future<Response> updateRequestWithFormData(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    String? userToken = getToken();
    String language = getCurrentLanguage();
    return _dio.put(
      endpoint,
      data: data,
      queryParameters: queryParams,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          "Accept": "application/json",
          "Authorization": "Bearer $userToken",
          "locale": language,
          ...?headers,
        },
      ),
    );
  }
}

class ApiConstants {
  static const String apiBaseUrl = "https://achievers.codenesslab.com/api/";

  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String categoriesList = "/categories";
  static const String updateProfile = "/updateProfile";

  static const String sendEmailOTP = "/send-email-otp";
  static const String verifyOTP = "/verify-otp";
  static const String updatePassword = "/resetPassword";
  static const String socialLogin = "/auth/social/auth";

  static const String userProfile = "/user";
  static const String homeCategoriesChallenges = "/categorieChallenges";
  static const String homeRecommendedChallenges = "/recommendedChallenges";
  static const String homeAllCategoriesAndChallenges =
      "/getAllCategoryChallenges";
  static const String homeCreateChallenge = "/challenges";
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

