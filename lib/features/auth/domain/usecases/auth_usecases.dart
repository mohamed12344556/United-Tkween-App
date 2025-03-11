import 'package:dartz/dartz.dart';
import '../entities/user_login_entity.dart';
import '../entities/user_reset_password_entity.dart';
import '../repos/auth_repository.dart';

import '../../../../core/core.dart';


// Login UseCase
class LoginUseCase implements UseCase<ApiErrorModel, Unit, UserLoginEntity> {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  @override
  Future<Either<ApiErrorModel, Unit>> call(UserLoginEntity params) async {
    try {
      return await authRepository.login(userLoginEntity: params);
    } on Exception catch (e) {
      return Future.value(Left(
        ApiErrorModel(errorMessage: ErrorData(message: e.toString())),
      ));
    }
  }
}

// Register UseCase
class RegisterUseCase implements UseCase<ApiErrorModel, Unit, UserLoginEntity> {
  final AuthRepository authRepository;

  RegisterUseCase({required this.authRepository});

  @override
  Future<Either<ApiErrorModel, Unit>> call(UserLoginEntity params) async {
    try {
      return await authRepository.register(userLoginEntity: params);
    } on Exception catch (e) {
      return Future.value(Left(
        ApiErrorModel(errorMessage: ErrorData(message: e.toString())),
      ));
    }
  }
}

// Reset Password UseCase
class ResetPasswordUseCase implements UseCase<ApiErrorModel, Unit, UserResetPasswordEntity> {
  final AuthRepository authRepository;

  ResetPasswordUseCase({required this.authRepository});

  @override
  Future<Either<ApiErrorModel, Unit>> call(UserResetPasswordEntity params) async {
    try {
      return await authRepository.resetPassword(userResetPasswordEntity: params);
    } on Exception catch (e) {
      return Future.value(Left(
        ApiErrorModel(errorMessage: ErrorData(message: e.toString())),
      ));
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
      return await authRepository.sendOtp(email: params.email, purpose: params.purpose);
    } on Exception catch (e) {
      return Future.value(Left(
        ApiErrorModel(errorMessage: ErrorData(message: e.toString())),
      ));
    }
  }
}

// Verify OTP UseCase
class VerifyOtpParams {
  final String otp;
  final String email;

  VerifyOtpParams({required this.otp, required this.email});
}

class VerifyOtpUseCase implements UseCase<ApiErrorModel, Unit, VerifyOtpParams> {
  final AuthRepository authRepository;

  VerifyOtpUseCase({required this.authRepository});

  @override
  Future<Either<ApiErrorModel, Unit>> call(VerifyOtpParams params) async {
    try {
      return await authRepository.verifyOtp(otp: params.otp, email: params.email);
    } on Exception catch (e) {
      return Future.value(Left(
        ApiErrorModel(errorMessage: ErrorData(message: e.toString())),
      ));
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
    } on Exception catch (e) {
      return Future.value(Left(
        ApiErrorModel(errorMessage: ErrorData(message: e.toString())),
      ));
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
    } on Exception catch (e) {
      return Future.value(Left(
        ApiErrorModel(errorMessage: ErrorData(message: e.toString())),
      ));
    }
  }
}