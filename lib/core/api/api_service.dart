import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:united_formation_app/features/auth/data/models/login_model.dart';
import 'package:united_formation_app/features/auth/data/models/otp_verification_model.dart';
import 'package:united_formation_app/features/auth/data/models/reset_password_model.dart';
import 'package:united_formation_app/features/auth/data/models/send_otp_model.dart';

import '../core.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @POST(ApiConstants.login)  // Make sure to define this constant
Future<LoginModel> login(@Body() LoginModel request);

  @POST(ApiConstants.signup)
  Future<LoginModel> signup(@Body() LoginModel request);

  @POST(ApiConstants.resetPassword)
  Future<ResetPasswordModel> resetPassword(@Body() ResetPasswordModel request);

  @POST(ApiConstants.forgotPassword)
  Future<SendOtpModel> sendOtp(@Body() SendOtpModel request);

  @POST(ApiConstants.verifyResetPasswordOTP)
  Future<OtpVerificationModel> verifyOtp(@Body() OtpVerificationModel request);
}

//! command to run the service file generator
//? flutter pub run build_runner build --delete-conflicting-outputs
