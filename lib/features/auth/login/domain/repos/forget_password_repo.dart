import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/auth/login/domain/entities/user_reset_password_entity.dart';

import '../../../../../core/error/api_error_model.dart';

abstract class ForgetPasswordRepo {
  Future<Either<ApiErrorModel, Unit>> resetPassWord({
    required UserResetPasswordEntity userResetPasswordEntity,
  });

  Future<Either<ApiErrorModel, Unit>> sentOtp({required String email});

  Future<Either<ApiErrorModel, Unit>> verifyOtp({
    required String otp,
    required String email,
  });
}
