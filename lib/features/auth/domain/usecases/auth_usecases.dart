import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/auth/data/models/login/login_model_response.dart';
import 'package:united_formation_app/features/auth/data/models/register/register_model_response.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_register_entity.dart';
import '../../data/services/delete_account_service.dart';
import '../entities/user_login_entity.dart';
import '../entities/user_reset_password_entity.dart';
import '../repos/auth_repository.dart';

import '../../../../core/core.dart';

//? Login UseCase
class LoginUseCase
    implements UseCase<ApiErrorModel, LoginModelResponse, UserLoginEntity> {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  @override
  Future<Either<ApiErrorModel, LoginModelResponse>> call(
    UserLoginEntity params,
  ) async {
    try {
      return await authRepository.login(userLoginEntity: params);
    } catch (e) {
      return Left(ApiErrorModel(status: 'error', errorMessage: e.toString()));
    }
  }
}

//? Register UseCase
class RegisterUseCase
    implements
        UseCase<ApiErrorModel, RegisterModelResponse, UserRegisterEntity> {
  final AuthRepository authRepository;

  RegisterUseCase({required this.authRepository});

  @override
  Future<Either<ApiErrorModel, RegisterModelResponse>> call(
    UserRegisterEntity params,
  ) async {
    try {
      return await authRepository.register(userRegisterEntity: params);
    } catch (e) {
      return Left(ApiErrorModel(status: 'error', errorMessage: e.toString()));
    }
  }
}

// Reset Password UseCase
class ResetPasswordUseCase
    implements UseCase<ApiErrorModel, Unit, UserResetPasswordEntity> {
  final AuthRepository authRepository;

  ResetPasswordUseCase({required this.authRepository});

  @override
  Future<Either<ApiErrorModel, Unit>> call(
    UserResetPasswordEntity params,
  ) async {
    try {
      return await authRepository.resetPassword(
        userResetPasswordEntity: params,
      );
    } catch (e) {
      return Left(ApiErrorModel(status: 'error', errorMessage: e.toString()));
    }
  }
}

// Send OTP UseCase
class SendOtpParams {
  final String email;
  final OtpPurpose purpose;

  SendOtpParams({required this.email, required this.purpose});
}

class SendOtpUseCase implements UseCase<ApiErrorModel, Unit, SendOtpParams> {
  final AuthRepository authRepository;

  SendOtpUseCase({required this.authRepository});

  @override
  Future<Either<ApiErrorModel, Unit>> call(SendOtpParams params) async {
    try {
      return await authRepository.sendOtp(
        email: params.email,
        purpose: params.purpose,
      );
    } catch (e) {
      return Left(ApiErrorModel(status: 'error', errorMessage: e.toString()));
    }
  }
}

// Verify OTP UseCase
class VerifyOtpParams {
  final String otp;
  final String email;

  VerifyOtpParams({required this.otp, required this.email});
}

class VerifyOtpUseCase
    implements UseCase<ApiErrorModel, Unit, VerifyOtpParams> {
  final AuthRepository authRepository;

  VerifyOtpUseCase({required this.authRepository});

  @override
  Future<Either<ApiErrorModel, Unit>> call(VerifyOtpParams params) async {
    try {
      return await authRepository.verifyOtp(
        otp: params.otp,
        email: params.email,
      );
    } catch (e) {
      return Left(ApiErrorModel(status: 'error', errorMessage: e.toString()));
    }
  }
}

// Check Login Status UseCase
class IsLoggedInUseCase implements NoParamUseCase<ApiErrorModel, bool> {
  final AuthRepository authRepository;

  IsLoggedInUseCase({required this.authRepository});

  @override
  Future<Either<ApiErrorModel, bool>> call() async {
    try {
      return await authRepository.isLoggedIn();
    } catch (e) {
      return Left(ApiErrorModel(status: 'error', errorMessage: e.toString()));
    }
  }
}

// Logout UseCase
class LogoutUseCase implements NoParamUseCase<ApiErrorModel, Unit> {
  final AuthRepository authRepository;

  LogoutUseCase({required this.authRepository});

  @override
  Future<Either<ApiErrorModel, Unit>> call() async {
    try {
      return await authRepository.logout();
    } catch (e) {
      return Left(ApiErrorModel(status: 'error', errorMessage: e.toString()));
    }
  }
}
