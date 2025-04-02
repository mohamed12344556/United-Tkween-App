import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:united_formation_app/features/auth/data/models/login/login_model_request_body.dart';
import 'package:united_formation_app/features/auth/data/models/login/login_model_response.dart';
import 'package:united_formation_app/features/auth/data/models/register/register_model_request_body.dart';
import 'package:united_formation_app/features/auth/data/models/register/register_model_response.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_login_entity.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_register_entity.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_reset_password_entity.dart';

import '../../../../core/api/dio_services.dart';
import '../../../../core/core.dart';

abstract class AuthRemoteDataSource {
  Future<LoginModelResponse> login({required UserLoginEntity userLoginEntity});
  Future<RegisterModelResponse> register({
    required UserRegisterEntity userRegisterEntity,
  });
  Future<Unit> resetPassword({
    required UserResetPasswordEntity userResetPasswordEntity,
  });
  Future<Unit> sendOtp({required String email, required OtpPurpose purpose});
  Future<Unit> verifyOtp({required String otp, required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final ApiService service;

  AuthRemoteDataSourceImpl({required this.dio, required this.service});

  @override
  Future<LoginModelResponse> login({
    required UserLoginEntity userLoginEntity,
  }) async {
    try {
      final requestModel = LoginRequestModel(
        email: userLoginEntity.email,
        password: userLoginEntity.password,
      );

      final response = await service.login(requestModel);

      if (response.status == 'success' && response.token != null) {
        await TokenManager.saveTokens(token: response.token!);
        await Prefs.setData(key: StorageKeys.isLoggedIn, value: true);
        debugPrint('✅ Login successful: ${response.userData?.name}');
        return response;
      } else {
        return response;
      }
    } catch (e) {
      debugPrint('❌ Login error: $e');
      throw Exception('فشل تسجيل الدخول: $e');
    }
  }

  @override
  Future<RegisterModelResponse> register({
    required UserRegisterEntity userRegisterEntity,
  }) async {
    try {
      final requestModel = RegisterModelRequestBody(
        fullName: userRegisterEntity.fullName,
        email: userRegisterEntity.email,
        phone:
            userRegisterEntity.phoneNumber?.isEmpty == true
                ? "1111111"
                : userRegisterEntity.phoneNumber,
        password: userRegisterEntity.password,
        address:
            userRegisterEntity.address?.isEmpty == true
                ? "Default Address"
                : userRegisterEntity.address,
      );

      debugPrint('Calling register API with requestModel: $requestModel');

      final response = await service.register(requestModel);

      return response;
    } catch (e) {
      debugPrint('Login error: $e');
      throw Exception('فشل تسجيل الدخول: $e');
    }
  }

  // الوظائف التالية تبقى كما هي لأن API تكوين لا يدعمها حاليًا
  @override
  Future<Unit> resetPassword({
    required UserResetPasswordEntity userResetPasswordEntity,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    print(
      "✅ تم إعادة تعيين كلمة المرور بنجاح لـ ${userResetPasswordEntity.email}",
    );
    return unit;
  }

  @override
  Future<Unit> sendOtp({
    required String email,
    required OtpPurpose purpose,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    print("✅ تم إرسال رمز التحقق إلى $email");
    return unit;
  }

  @override
  Future<Unit> verifyOtp({required String otp, required String email}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (otp == "1234") {
      print("✅ تم التحقق من رمز OTP بنجاح لـ $email");
      return unit;
    } else {
      throw Exception("❌ فشل التحقق من رمز OTP: رمز غير صحيح");
    }
  }
}
