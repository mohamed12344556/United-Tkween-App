import 'package:dartz/dartz.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/login/domain/repos/forget_password_repo.dart';

class SendOtpUseCase implements UseCase<ApiErrorModel, Unit, String> {
  final ForgetPasswordRepo forgetPasswordRepo;

  SendOtpUseCase({required this.forgetPasswordRepo});

  @override
  Future<Either<ApiErrorModel, Unit>> call(String email) async {
    try {
      return await forgetPasswordRepo.sentOtp(email: email);
    } on Exception catch (e) {
      return Future.error(
        ApiErrorModel(errorMessage: ErrorData(message: e.toString())),
      );
    }
  }
}