import 'package:united_formation_app/features/auth/login/data/models/login_model.dart';
import 'package:united_formation_app/features/auth/login/domain/entities/user_login_entity.dart';

abstract class LoginRemoteDataSource {
  Future<UserLoginEntity> login({required UserLoginEntity userLoginEntity});
}

class LoginRemoteDataSourceImp implements LoginRemoteDataSource {
  final LoginModel loginModel;
  LoginRemoteDataSourceImp({required this.loginModel});
  @override
  Future<UserLoginEntity> login({required UserLoginEntity userLoginEntity}) {
    // TODO: implement login
    throw UnimplementedError();
  }
}
