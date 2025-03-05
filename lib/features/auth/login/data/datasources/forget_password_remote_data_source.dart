import 'package:dartz/dartz.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/login/data/models/otp_verification_model.dart';
import 'package:united_formation_app/features/auth/login/data/models/reset_password_model.dart';
import 'package:united_formation_app/features/auth/login/data/models/send_otp_model.dart';
import 'package:united_formation_app/features/auth/login/domain/entities/user_reset_password_entity.dart';

abstract class ForgetPasswordRemoteDataSource {
  Future<Unit> resetPassword({
    required UserResetPasswordEntity userResetPasswordEntity,
  });
  Future<Unit> sendOtp({required String email});
  Future<Unit> verifyOtp({required String otp, required String email});
}

class ForgetPasswordRemoteDataSourceImp
    implements ForgetPasswordRemoteDataSource {
  final ApiService service;

  ForgetPasswordRemoteDataSourceImp({required this.service});

  @override
  Future<Unit> resetPassword({
    required UserResetPasswordEntity userResetPasswordEntity,
  }) async {
    final resetPasswordModel = ResetPasswordModel(
      email: userResetPasswordEntity.email,
      resetToken: userResetPasswordEntity.resetToken,
      password: userResetPasswordEntity.password,
      passwordConfirmation: userResetPasswordEntity.passwordConfirmation,
    );

    return await service
        .resetPassword(resetPasswordModel)
        .then((response) {
          return unit;
        })
        .catchError((error) {
          throw error;
        });
  }

  @override
  Future<Unit> sendOtp({required String email}) async {
    return await service
        .sendOtp(SendOtpModel(email: email))
        .then((response) {
          return unit;
        })
        .catchError((error) {
          throw error;
        });
  }

  @override
  Future<Unit> verifyOtp({required String otp, required String email}) async {
    return await service
        .verifyOtp(OtpVerificationModel(otp: otp, email: email))
        .then((response) {
          return unit;
        })
        .catchError((error) {
          throw error;
        });
  }
}
