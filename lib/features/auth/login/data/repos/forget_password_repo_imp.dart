import 'package:dartz/dartz.dart';
import 'package:united_formation_app/core/error/api_error_model.dart';
import 'package:united_formation_app/features/auth/login/data/datasources/forget_password_remote_data_source.dart';
import 'package:united_formation_app/features/auth/login/domain/entities/user_reset_password_entity.dart';
import 'package:united_formation_app/features/auth/login/domain/repos/forget_password_repo.dart';

class ForgetPasswordRepoImp implements ForgetPasswordRepo {
  final ForgetPasswordRemoteDataSource forgetPasswordRemoteDataSource;

  ForgetPasswordRepoImp(this.forgetPasswordRemoteDataSource);

  @override
  Future<Either<ApiErrorModel, Unit>> resetPassWord({
    required UserResetPasswordEntity userResetPasswordEntity,
  }) async {
    try {
      await forgetPasswordRemoteDataSource.resetPassword(
        userResetPasswordEntity: userResetPasswordEntity,
      );
      return Right(unit);
    } catch (error) {
      return Left(
        ApiErrorModel(errorMessage: ErrorData(message: error.toString())),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, Unit>> sentOtp({required String email}) async {
    try {
      await forgetPasswordRemoteDataSource.sendOtp(email: email);
      return Right(unit);
    } catch (error) {
      return Left(
        ApiErrorModel(errorMessage: ErrorData(message: error.toString())),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, Unit>> verifyOtp({
    required String otp,
    required String email,
  }) async {
    try {
      await forgetPasswordRemoteDataSource.verifyOtp(otp: otp, email: email);
      return Right(unit);
    } catch (error) {
      return Left(
        ApiErrorModel(errorMessage: ErrorData(message: error.toString())),
      );
    }
  }
}