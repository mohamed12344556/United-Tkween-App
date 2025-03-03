import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/auth/login/domain/entities/user_login_entity.dart';

import '../../../../../core/core.dart';

abstract class LoginRepo {
  Future<Either<ApiErrorModel, Unit>> login({required UserLoginEntity userLoginEntity});
}