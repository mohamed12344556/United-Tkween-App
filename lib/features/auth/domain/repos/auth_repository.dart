import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_login_entity.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_reset_password_entity.dart';

import '../../../../core/core.dart';


abstract class AuthRepository {
  Future<Either<ApiErrorModel, Unit>> login({required UserLoginEntity userLoginEntity});
  Future<Either<ApiErrorModel, Unit>> register({required UserLoginEntity userLoginEntity});
  Future<Either<ApiErrorModel, Unit>> resetPassword({required UserResetPasswordEntity userResetPasswordEntity});
  Future<Either<ApiErrorModel, Unit>> sendOtp({required String email, required OtpPurpose purpose});
  Future<Either<ApiErrorModel, Unit>> verifyOtp({required String otp, required String email});
  Future<Either<ApiErrorModel, bool>> isLoggedIn();
  Future<Either<ApiErrorModel, Unit>> logout();
}