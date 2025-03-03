import 'package:dartz/dartz.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/login/domain/repos/login_repo.dart';

import '../entities/user_login_entity.dart';

class LoginUseCase
    implements UseCase<ApiErrorModel, Unit, UserLoginEntity> {
  final LoginRepo loginRepo;

  LoginUseCase({required this.loginRepo});

  @override
  Future<Either<ApiErrorModel, Unit>> call(UserLoginEntity params) async {
    try {
      return await loginRepo.login(userLoginEntity: params);
    } on Exception catch (e) {
      return Future.error(
        ApiErrorModel(errorMessage: ErrorData(message: e.toString())),
      );
    }
  }
}
