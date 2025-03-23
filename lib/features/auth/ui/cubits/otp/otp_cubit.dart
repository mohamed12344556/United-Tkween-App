// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../core/core.dart';
// import '../../../domain/usecases/auth_usecases.dart';

// part 'otp_state.dart';

// class OtpCubit extends Cubit<OtpState> {
//   final VerifyOtpUseCase? verifyOtpUseCase;
//   final SendOtpUseCase? sendOtpUseCase;
//   final String email;
//   final OtpPurpose purpose;

//   bool _isDisposed = false;
//   Timer? _otpTimer;
//   int _otpTimeRemaining = 60;

//   int get otpTimeRemaining => _otpTimeRemaining;

//   OtpCubit({
//     required this.email,
//     this.verifyOtpUseCase,
//     this.sendOtpUseCase,
//     this.purpose = OtpPurpose.accountVerification,
//   }) : super(OtpInitial()) {
//     _requestOtpOnInit();
//   }

//   bool get isActive => !_isDisposed;

//   Future<void> _requestOtpOnInit() async {
//     try {
//       emit(OtpLoading());
      
//       if (sendOtpUseCase != null) {
//         final result = await sendOtpUseCase!(
//           SendOtpParams(email: email, purpose: purpose)
//         );
        
//         if (!isActive) return;
        
//         result.fold(
//           (failure) => emit(
//             OtpError(
//               message:
//                   failure.errorMessage?? 'Unknown error occurred',
//             ),
//           ),
//           (_) {
//             _startOtpTimer();
//             emit(OtpInitial());
//           },
//         );
//       } else {
//         // Mock implementation for development
//         await Future.delayed(Duration(seconds: 1));
        
//         if (!isActive) return;
        
//         _startOtpTimer();
//         emit(OtpInitial());
//       }
//     } catch (e) {
//       if (isActive) {
//         emit(OtpError(message: e.toString()));
//       }
//     }
//   }

//   void startTimer() {
//     if (_otpTimeRemaining <= 0) {
//       _startOtpTimer();
//     }
//   }

//   void initTimer() {
//     _startOtpTimer();
//   }

//   Future<void> verifyOtp({required String otp, required BuildContext context}) async {
//     try {
//       if (!isActive) return;
      
//       if (otp.isEmpty || otp.length < 4) {
//         emit(OtpError(message: context.localeS.please_enter_valid_otp));
//         return;
//       }
      
//       emit(OtpLoading());
      
//       if (verifyOtpUseCase != null) {
//         final result = await verifyOtpUseCase!(
//           VerifyOtpParams(otp: otp, email: email),
//         );
        
//         if (!isActive) return;
        
//         result.fold(
//           (failure) => emit(
//             OtpError(
//               message:
//                   failure.errorMessage?? 'Unknown error occurred',
//             ),
//           ),
//           (_) {
//             _cancelTimer();
//             emit(OtpVerified(purpose: purpose));
//           },
//         );
//       } else {
//         // Mock implementation for development
//         await Future.delayed(Duration(seconds: 1));
        
//         if (!isActive) return;
        
//         _cancelTimer();
//         emit(OtpVerified(purpose: purpose));
//       }
//     } catch (e) {
//       if (isActive) {
//         emit(OtpError(message: e.toString()));
//       }
//     }
//   }

//   void _startOtpTimer() {
//     _cancelTimer();
//     _otpTimeRemaining = 60;
//     _otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_otpTimeRemaining > 0) {
//         _otpTimeRemaining--;
//         if (isActive) {
//           emit(OtpTimerUpdated(timeRemaining: _otpTimeRemaining));
//         }
//       } else {
//         _cancelTimer();
//       }
//     });
//   }

//   Future<void> resendOtp() async {
//     if (!isActive || _otpTimeRemaining > 0) return;
    
//     emit(OtpLoading());
    
//     if (sendOtpUseCase != null) {
//       final result = await sendOtpUseCase!(
//         SendOtpParams(email: email, purpose: purpose)
//       );
      
//       if (!isActive) return;
      
//       result.fold(
//         (failure) => emit(
//           OtpError(
//             message: failure.errorMessage?? 'Unknown error occurred',
//           ),
//         ),
//         (_) {
//           _startOtpTimer();
//           emit(OtpResent());
//         },
//       );
//     } else {
//       // Mock implementation for development
//       await Future.delayed(Duration(seconds: 1));
      
//       if (!isActive) return;
      
//       _startOtpTimer();
//       emit(OtpResent());
//     }
//   }

//   // إضافة طريقة صريحة لإلغاء المؤقت
//   void cancelTimer() {
//     _otpTimer?.cancel();
//     _otpTimer = null;
//   }

//   void _cancelTimer() {
//     _otpTimer?.cancel();
//     _otpTimer = null;
//   }

//   @override
//   Future<void> close() {
//     _cancelTimer();
//     _isDisposed = true;
//     return super.close();
//   }
// }