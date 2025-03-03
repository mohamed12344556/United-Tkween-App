import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/auth/login/domain/entities/user_login_entity.dart';

import '../../../../../core/core.dart';

abstract class LoginRemoteDataSource {
  Future<Unit> login({required UserLoginEntity userLoginEntity});
}

class LoginRemoteDataSourceImp implements LoginRemoteDataSource {
  final ApiService service;

  LoginRemoteDataSourceImp({required this.service});
  @override
  Future<Unit> login({required UserLoginEntity userLoginEntity}) {
    // TODO: implement login
    throw UnimplementedError();
  }
}
