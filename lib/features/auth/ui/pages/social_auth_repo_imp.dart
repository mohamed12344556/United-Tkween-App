import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:united_formation_app/core/api/dio_services.dart';
import 'package:united_formation_app/core/api/dio_services_failures.dart';
import 'package:united_formation_app/features/auth/ui/pages/server.dart';
import 'package:united_formation_app/features/auth/ui/pages/social_auth_repo.dart';
import 'package:united_formation_app/features/auth/ui/pages/user_model.dart';

class SocialAuthRepoImpl extends SocialAuthRepo {
  final ApiService apiService = ApiService();

  SocialAuthRepoImpl();

  @override
  Future<Either<Failure, UserModel>> signInWithGoogle({required String firebaseToken,context}) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return left(ServerFailure('Login cancelled'));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return left(ServerFailure('Failed to retrieve user information'));
      }
      print("🚹FirebaseToken: ${firebaseToken}");

      final Map<String, dynamic> body = {
        "name": firebaseUser.displayName ?? '',
        "id": firebaseUser.uid,
        "email": firebaseUser.email ?? '',
        "provider": "google",
        "fb_token": firebaseToken
      };

      Response apiResponse;

      try {
        apiResponse =
            await apiService.postRequest(ApiConstants.socialLogin, data: body);
      } catch (dioError) {
        return left(ServerFailure.fromDioException(dioError as DioException,context));
      }
      if (apiResponse.statusCode == 200 || apiResponse.statusCode == 201) {
        final userModel = UserModel.fromJson(apiResponse.data);

         Prefs.setData(key: Constants.userToken, value: userModel.token);


        await HiveService().saveUser(userModel);

        return right(userModel);
      } else {
        return left(ServerFailure.fromResponse(
            apiResponse.statusCode, apiResponse.data,context));
      }
    } catch (e) {
      log("❌ Exception: $e");
      if (e is FirebaseAuthException) {
        return left(ServerFailure(e.message ?? 'Authentication error'));
      } else if (e is DioException) {
        return left(ServerFailure.fromDioException(e,context));
      }
      log('Exception in signInWithGoogle || Auth Repo Impl : ${e.toString()}');
      return left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithFacebook({required String firebaseToken,context}) async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final LoginResult loginResult =
      await FacebookAuth.instance.login(nonce: nonce);

      if (loginResult.status != LoginStatus.success || loginResult.accessToken == null) {
        return left(ServerFailure(loginResult.message ?? 'Facebook login failed'));
      }

      OAuthCredential facebookAuthCredential;

      if (Platform.isIOS) {
        switch (loginResult.accessToken!.type) {
          case AccessTokenType.classic:
            final token = loginResult.accessToken as ClassicToken;
            facebookAuthCredential = FacebookAuthProvider.credential(
              token.authenticationToken!,
            );
            break;
          case AccessTokenType.limited:
            final token = loginResult.accessToken as LimitedToken;
            facebookAuthCredential = OAuthCredential(
              providerId: 'facebook.com',
              signInMethod: 'oauth',
              idToken: token.tokenString,
              rawNonce: rawNonce,
            );
            break;
          default:
            return left(ServerFailure("Unknown Facebook token type"));
        }
      } else {
        facebookAuthCredential = FacebookAuthProvider.credential(
          loginResult.accessToken!.tokenString,
        );
      }

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return left(ServerFailure('Failed to retrieve user information'));
      }
      log("🚹FirebaseToken Facebook: ${firebaseToken}");
      final Map<String, dynamic> body = {
        "name": firebaseUser.displayName ?? '',
        "id": firebaseUser.uid,
        "email": firebaseUser.email ?? '',
        "provider": "facebook",
        "fb_token": firebaseToken
      };

      Response apiResponse;

      try {
        apiResponse =
        await apiService.postRequest(ApiConstants.socialLogin, data: body);
      } catch (dioError) {
        return left(ServerFailure.fromDioException(dioError as DioException,context));
      }

      if (apiResponse.statusCode == 200 || apiResponse.statusCode == 201) {
        final userModel = UserModel.fromJson(apiResponse.data);

        Prefs.setData(key: Constants.userToken, value: userModel.token);

        await HiveService().saveUser(userModel);

        return right(userModel);
      } else {
        return left(ServerFailure.fromResponse(
            apiResponse.statusCode, apiResponse.data ,context));
      }
    } catch (e) {
      log("❌ Exception: $e");
      if (e is FirebaseAuthException) {
        return left(ServerFailure(e.message ?? 'Authentication error'));
      } else if (e is DioException) {
        return left(ServerFailure.fromDioException(e,context));
      }
      log('Exception in signInWithFacebook || Auth Repo Impl : ${e.toString()}');
      return left(ServerFailure('Unexpected error occurred'));
    }
  }


  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<Either<Failure, UserModel>> signInWithApple({required String firebaseToken,context}) async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      if (appleCredential.identityToken == null) {
        return left(ServerFailure('Apple Sign-In failed: No identity token'));
      }

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return left(ServerFailure('Failed to retrieve user information'));
      }

      final Map<String, dynamic> body = {
        "name": appleCredential.givenName ?? firebaseUser.displayName ?? '',
        "id": firebaseUser.uid,
        "email": firebaseUser.email ?? '',
        "provider": "apple",
        "fb_token": firebaseToken
      };

      Response apiResponse;

      try {
        apiResponse =
            await apiService.postRequest(ApiConstants.socialLogin, data: body);
      } catch (dioError) {
        log("❌ DioException: $dioError");
        return left(ServerFailure.fromDioException(dioError as DioException,context));
      }

      log("✅ Response Data: ${apiResponse.data}");

      if (apiResponse.statusCode == 200 || apiResponse.statusCode == 201) {
        final userModel = UserModel.fromJson(apiResponse.data);

        Prefs.setData(key: Constants.userToken, value: userModel.token);

        await HiveService().saveUser(userModel);

        return right(userModel);
      } else {
        return left(ServerFailure.fromResponse(
            apiResponse.statusCode, apiResponse.data,context));
      }
    } catch (e) {
      log("❌ Exception: $e");
      if (e is FirebaseAuthException) {
        return left(ServerFailure(e.message ?? 'Authentication error'));
      } else if (e is DioException) {
        return left(ServerFailure.fromDioException(e,context));
      }
      log('Exception in signInWithApple || Auth Repo Impl : ${e.toString()}');
      return left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }
}


class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;

  HiveService._internal();

  final String boxName = 'userBox';

  Future<void> saveUser(UserModel user) async {
    var box = await Hive.openBox<UserModel>(boxName);
    await box.put('currentUser', user);
  }

  UserModel? getUser() {
    var box = Hive.box<UserModel>(boxName);
    return box.get('currentUser');
  }

  Future<void> updateUser(UserModel user) async {
    await saveUser(user);
  }

  Future<void> deleteUser() async {
    var box = await Hive.openBox<UserModel>(boxName);
    await box.delete('currentUser');
  }
}