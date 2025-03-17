import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/auth/ui/pages/falier.dart';
import 'package:united_formation_app/features/auth/ui/pages/user_model.dart' show UserModel;


abstract class SocialAuthRepo {
  Future<Either<Failure, UserModel>> signInWithGoogle({required String firebaseToken});

  Future<Either<Failure, UserModel>> signInWithFacebook({required String firebaseToken});

  Future<Either<Failure, UserModel>> signInWithApple({required String firebaseToken});

  bool isLoggedIn();
}