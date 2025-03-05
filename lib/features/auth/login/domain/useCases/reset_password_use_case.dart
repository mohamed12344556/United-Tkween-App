import 'package:dartz/dartz.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/login/domain/entities/user_reset_password_entity.dart';
import 'package:united_formation_app/features/auth/login/domain/repos/forget_password_repo.dart';

class ResetPasswordUseCase
    implements UseCase<ApiErrorModel, Unit, UserResetPasswordEntity> {
  final ForgetPasswordRepo forgetPasswordRepo;

  ResetPasswordUseCase({required this.forgetPasswordRepo});

  @override
  Future<Either<ApiErrorModel, Unit>> call(UserResetPasswordEntity params) async {
    try {
      return await forgetPasswordRepo.resetPassWord(userResetPasswordEntity: params);
    } on Exception catch (e) {
      return Future.error(
        ApiErrorModel(errorMessage: ErrorData(message: e.toString())),
      );
    }
  }
}