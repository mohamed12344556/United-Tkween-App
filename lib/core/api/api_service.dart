import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:united_formation_app/features/auth/data/models/login/login_model_response.dart';
import 'package:united_formation_app/features/auth/data/models/register/register_model_request_body.dart';
import 'package:united_formation_app/features/auth/data/models/register/register_model_response.dart';
import '../../features/auth/data/models/login/login_model_request_body.dart';
import '../../features/auth/data/models/otp_verification/otp_verification_model.dart';
import '../../features/auth/data/models/reset_password/reset_password_model.dart';

import '../../features/auth/data/models/send_otp/send_otp_model.dart';
import '../../features/settings/data/models/profile_model.dart';
import '../core.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @POST(ApiConstants.login)
  Future<LoginModelResponse> login(@Body() LoginRequestModel request);

  @POST(ApiConstants.register)
  Future<RegisterModelResponse> register(
    @Body() RegisterModelRequestBody request,
  );

  @POST(ApiConstants.resetPassword)
  Future<ResetPasswordModel> resetPassword(@Body() ResetPasswordModel request);

  @POST(ApiConstants.forgotPassword)
  Future<SendOtpModel> sendOtp(@Body() SendOtpModel request);

  @POST(ApiConstants.verifyResetPasswordOTP)
  Future<OtpVerificationModel> verifyOtp(@Body() OtpVerificationModel request);

  // Tkween Store API endpoints
  @POST(ApiConstants.updateProfile)
  Future<dynamic> updateProfile(@Body() Map<String, dynamic> profileData);

  @GET(ApiConstants.getOrders)
  Future<dynamic> getOrders();

  @GET(ApiConstants.getBooks)
  Future<dynamic> getBooks();

  @GET(ApiConstants.getCategories)
  Future<dynamic> getCategories();

  @POST(ApiConstants.createPurchase)
  Future<dynamic> createPurchase(@Body() Map<String, dynamic> purchaseData);

  @GET(ApiConstants.fetchLibrary)
  Future<dynamic> fetchLibrary();

  @GET(ApiConstants.getProfile)
  Future<dynamic> getProfile();
}

//! command to run the service file generator
//? flutter pub run build_runner build --delete-conflicting-outputs