import 'package:dartz/dartz.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/login/domain/repos/forget_password_repo.dart';

class VerifyOtpParams {
  final String otp;
  final String email;

  VerifyOtpParams({required this.otp, required this.email});
}

class VerifyOtpUseCase implements UseCase<ApiErrorModel, Unit, VerifyOtpParams> {
  final ForgetPasswordRepo forgetPasswordRepo;

  VerifyOtpUseCase({required this.forgetPasswordRepo});

  @override
  Future<Either<ApiErrorModel, Unit>> call(VerifyOtpParams params) async {
    try {
      return await forgetPasswordRepo.verifyOtp(
        otp: params.otp,
        email: params.email,
      );
    } on Exception catch (e) {
      return Future.error(
        ApiErrorModel(errorMessage: ErrorData(message: e.toString())),
      );
    }
  }
}