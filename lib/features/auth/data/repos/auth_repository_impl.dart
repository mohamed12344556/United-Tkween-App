import 'package:dartz/dartz.dart';
import 'package:united_formation_app/core/utilities/enums/otp_purpose.dart'
    as remote;
import 'package:united_formation_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:united_formation_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_login_entity.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_reset_password_entity.dart';
import 'package:united_formation_app/features/auth/domain/repos/auth_repository.dart';

import '../../../../core/core.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<ApiErrorModel, Unit>> login({
    required UserLoginEntity userLoginEntity,
  }) async {
    try {
      await remoteDataSource.login(userLoginEntity: userLoginEntity);
      return const Right(unit);
    } catch (error) {
      return Left(
        ApiErrorModel(errorMessage: ErrorData(message: error.toString())),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, Unit>> register({
    required UserLoginEntity userLoginEntity,
  }) async {
    try {
      await remoteDataSource.register(userLoginEntity: userLoginEntity);
      return const Right(unit);
    } catch (error) {
      return Left(
        ApiErrorModel(errorMessage: ErrorData(message: error.toString())),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, Unit>> resetPassword({
    required UserResetPasswordEntity userResetPasswordEntity,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        userResetPasswordEntity: userResetPasswordEntity,
      );
      return const Right(unit);
    } catch (error) {
      return Left(
        ApiErrorModel(errorMessage: ErrorData(message: error.toString())),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, Unit>> sendOtp({
    required String email,
    required remote.OtpPurpose purpose,
  }) async {
    try {
      await remoteDataSource.sendOtp(email: email, purpose: purpose);
      return const Right(unit);
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
      await remoteDataSource.verifyOtp(otp: otp, email: email);
      return const Right(unit);
    } catch (error) {
      return Left(
        ApiErrorModel(errorMessage: ErrorData(message: error.toString())),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, bool>> isLoggedIn() async {
    try {
      final result = await localDataSource.hasValidTokens();
      return Right(result);
    } catch (error) {
      return Left(
        ApiErrorModel(errorMessage: ErrorData(message: error.toString())),
      );
    }
  }

  @override
  Future<Either<ApiErrorModel, Unit>> logout() async {
    try {
      await localDataSource.clearAuthTokens();
      return const Right(unit);
    } catch (error) {
      return Left(
        ApiErrorModel(errorMessage: ErrorData(message: error.toString())),
      );
    }
  }
}
