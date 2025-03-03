import 'package:dartz/dartz.dart';
import 'package:united_formation_app/core/error/api_error_model.dart';
import 'package:united_formation_app/features/auth/login/data/datasources/login_remote_data_source.dart';
import 'package:united_formation_app/features/auth/login/domain/entities/user_login_entity.dart';
import 'package:united_formation_app/features/auth/login/domain/repos/login_repo.dart';

class LoginRepoImp implements LoginRepo {
  final LoginRemoteDataSource loginRemoteDataSource;
  LoginRepoImp(this.loginRemoteDataSource);
  @override
  Future<Either<ApiErrorModel, UserLoginEntity>> login({
    required UserLoginEntity userLoginEntity,
  }) async {
    try {
      final result = await loginRemoteDataSource.login(userLoginEntity: userLoginEntity);
      return Right(result);
    } catch (error) {
      return Left(ApiErrorModel(errorMessage: ErrorData(message: error.toString())));
    }
  }
}
