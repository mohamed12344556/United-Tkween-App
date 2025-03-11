// import 'package:dartz/dartz.dart';
// import 'package:united_formation_app/features/auth/data/models/otp_verification_model.dart';
// import 'package:united_formation_app/features/auth/data/models/reset_password_model.dart';

// import 'package:united_formation_app/features/auth/data/models/send_otp_model.dart';
// import 'package:united_formation_app/features/auth/domain/entities/user_login_entity.dart';
// import 'package:united_formation_app/features/auth/domain/entities/user_reset_password_entity.dart';

// import '../../../../core/core.dart';
// import '../models/login_model.dart';

// abstract class AuthRemoteDataSource {
//   Future<Unit> login({required UserLoginEntity userLoginEntity});
//   Future<Unit> register({required UserLoginEntity userLoginEntity});
//   Future<Unit> resetPassword({required UserResetPasswordEntity userResetPasswordEntity});
//   Future<Unit> sendOtp({required String email, required OtpPurpose purpose});
//   Future<Unit> verifyOtp({required String otp, required String email});
// }

// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final ApiService service;

//   AuthRemoteDataSourceImpl({required this.service});

//   @override
//   Future<Unit> login({required UserLoginEntity userLoginEntity}) async {
//     final loginModel = LoginModel(
//       email: userLoginEntity.email,
//       password: userLoginEntity.password,
//     );
//     return await service
//         .login(loginModel)
//         .then((response) {
//           return unit;
//         })
//         .catchError((error) {
//           throw error;
//         });
//   }

//   @override
//   Future<Unit> register({required UserLoginEntity userLoginEntity}) async {
//     final loginModel = LoginModel(
//       email: userLoginEntity.email,
//       password: userLoginEntity.password,
//     );
//     return await service
//         .signup(loginModel)
//         .then((response) {
//           return unit;
//         })
//         .catchError((error) {
//           throw error;
//         });
//   }

//   @override
//   Future<Unit> resetPassword({required UserResetPasswordEntity userResetPasswordEntity}) async {
//     final resetPasswordModel = ResetPasswordModel(
//       email: userResetPasswordEntity.email,
//       resetToken: userResetPasswordEntity.resetToken,
//       password: userResetPasswordEntity.password,
//       passwordConfirmation: userResetPasswordEntity.passwordConfirmation,
//     );

//     return await service
//         .resetPassword(resetPasswordModel)
//         .then((response) {
//           return unit;
//         })
//         .catchError((error) {
//           throw error;
//         });
//   }

//   @override
//   Future<Unit> sendOtp({required String email, required OtpPurpose purpose}) async {
//     return await service
//         .sendOtp(SendOtpModel(email: email))
//         .then((response) {
//           return unit;
//         })
//         .catchError((error) {
//           throw error;
//         });
//   }

//   @override
//   Future<Unit> verifyOtp({required String otp, required String email}) async {
//     return await service
//         .verifyOtp(OtpVerificationModel(otp: otp, email: email))
//         .then((response) {
//           return unit;
//         })
//         .catchError((error) {
//           throw error;
//         });
//   }
// }

import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_login_entity.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_reset_password_entity.dart';

import '../../../../core/core.dart';

abstract class AuthRemoteDataSource {
  Future<Unit> login({required UserLoginEntity userLoginEntity});
  Future<Unit> register({required UserLoginEntity userLoginEntity});
  Future<Unit> resetPassword({
    required UserResetPasswordEntity userResetPasswordEntity,
  });
  Future<Unit> sendOtp({required String email, required OtpPurpose purpose});
  Future<Unit> verifyOtp({required String otp, required String email});
}

class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
  @override
  Future<Unit> login({required UserLoginEntity userLoginEntity}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (userLoginEntity.email == "test@example.com" &&
        userLoginEntity.password == "password123") {
      print("✅ Mock Login Success");
      return unit;
    } else {
      throw Exception("❌ Mock Login Failed: Invalid credentials");
    }
  }

  @override
  Future<Unit> register({required UserLoginEntity userLoginEntity}) async {
    await Future.delayed(const Duration(seconds: 2));
    print("✅ Mock Registration Success for ${userLoginEntity.email}");
    return unit;
  }

  @override
  Future<Unit> resetPassword({
    required UserResetPasswordEntity userResetPasswordEntity,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    print("✅ Mock Reset Password Success for ${userResetPasswordEntity.email}");
    return unit;
  }

  @override
  Future<Unit> sendOtp({
    required String email,
    required OtpPurpose purpose,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    print("✅ Mock OTP Sent to $email");
    return unit;
  }

  @override
  Future<Unit> verifyOtp({required String otp, required String email}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (otp == "1234") {
      print("✅ Mock OTP Verification Success for $email");
      return unit;
    } else {
      throw Exception("❌ Mock OTP Verification Failed: Incorrect OTP");
    }
  }
}
