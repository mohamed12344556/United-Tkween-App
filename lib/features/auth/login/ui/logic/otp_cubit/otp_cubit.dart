import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:united_formation_app/features/auth/login/domain/usecases/sent_otp_use_case.dart';
import 'package:united_formation_app/features/auth/login/domain/usecases/verify_otp_use_case.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

part 'otp_state.dart';

// إضافة enum للتمييز بين استخدامات OTP المختلفة
enum OtpPurpose { accountVerification, passwordReset }

class OtpCubit extends Cubit<OtpState> {
  // Use cases
  final VerifyOtpUseCase? verifyOtpUseCase;
  final SendOtpUseCase? sendOtpUseCase;

  // Email that we're verifying for
  final String email;

  // إضافة حقل الغرض
  final OtpPurpose purpose;

  // متغير لتتبع حالة التخلص من الكيوبت
  bool _isDisposed = false;

  // OTP Timer
  Timer? _otpTimer;
  int _otpTimeRemaining = 60; // 60 seconds timeout
  int get otpTimeRemaining => _otpTimeRemaining;

  OtpCubit({
    required this.email,
    this.verifyOtpUseCase,
    this.sendOtpUseCase,
    this.purpose = OtpPurpose.accountVerification,
  }) : super(OtpInitial()) {
    // تلقائيًا، نطلب OTP عند إنشاء الـ Cubit
    _requestOtpOnInit();
  }

  // دالة مساعدة للتحقق مما إذا كان الكيوبت ما زال نشطاً
  bool get isActive => !_isDisposed;

  // طلب OTP عند تهيئة الكيوبت
  Future<void> _requestOtpOnInit() async {
    try {
      // إظهار حالة التحميل
      emit(OtpLoading());

      // استدعاء API لإرسال OTP
      if (sendOtpUseCase != null) {
        final result = await sendOtpUseCase!(email);

        // التحقق من أن الكيوبت لم يتم التخلص منه
        if (!isActive) return;

        result.fold(
          (failure) => emit(
            OtpError(
              message:
                  failure.errorMessage?.message ?? 'Unknown error occurred',
            ),
          ),
          (_) {
            // بدء المؤقت وإظهار حالة إرسال OTP
            _startOtpTimer();
            emit(OtpInitial()); // إعادة تعيين الحالة بعد طلب OTP
          },
        );
      } else {
        // محاكاة API
        await Future.delayed(Duration(seconds: 1));

        // التحقق مرة أخرى
        if (!isActive) return;

        // بدء المؤقت
        _startOtpTimer();
        emit(OtpInitial());
      }
    } catch (e) {
      if (isActive) {
        emit(OtpError(message: e.toString()));
      }
    }
  }

  void startTimer() {
    if (_otpTimeRemaining <= 0) {
      _startOtpTimer();
    }
  }

  // Initialize the timer on creation
  void initTimer() {
    _startOtpTimer();
  }

  // Verify OTP code
  Future<void> verifyOtp({required String otp}) async {
    try {
      // التحقق من أن الكيوبت لم يتم التخلص منه بعد
      if (!isActive) return;

      // Validate OTP
      if (otp.isEmpty || otp.length < 4) {
        emit(OtpError(message: LocaleKeys.please_enter_valid_otp.tr()));
        return;
      }

      emit(OtpLoading());

      // If we have use case, use it, otherwise mock it for development
      if (verifyOtpUseCase != null) {
        final result = await verifyOtpUseCase!(
          VerifyOtpParams(otp: otp, email: email),
        );

        // التحقق مرة أخرى من أن الكيوبت لم يتم التخلص منه قبل إرسال الحدث
        if (!isActive) return;

        result.fold(
          (failure) => emit(
            OtpError(
              message:
                  failure.errorMessage?.message ?? 'Unknown error occurred',
            ),
          ),
          (_) {
            // إلغاء المؤقت قبل إرسال حالة النجاح - هذا أمر مهم جداً
            _cancelTimer();
            emit(OtpVerified(purpose: purpose));
          },
        );
      } else {
        // Mock implementation for development
        await Future.delayed(Duration(seconds: 1));

        // التحقق مرة أخرى من أن الكيوبت لم يتم التخلص منه قبل إرسال الحدث
        if (!isActive) return;

        // إلغاء المؤقت قبل إرسال حالة النجاح
        _cancelTimer();
        emit(OtpVerified(purpose: purpose));
      }
    } catch (e) {
      // التحقق من أن الكيوبت لم يتم التخلص منه قبل إرسال خطأ
      if (isActive) {
        emit(OtpError(message: e.toString()));
      }
    }
  }

  // Start OTP timer
  void _startOtpTimer() {
    _cancelTimer();
    _otpTimeRemaining = 60;
    _otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_otpTimeRemaining > 0) {
        _otpTimeRemaining--;

        // التحقق من أن الكيوبت لم يتم التخلص منه قبل إرسال تحديث المؤقت
        if (isActive) {
          emit(OtpTimerUpdated(timeRemaining: _otpTimeRemaining));
        }
      } else {
        _cancelTimer();
      }
    });
  }

  // Resend OTP
  Future<void> resendOtp() async {
    // التحقق من أن الكيوبت لم يتم التخلص منه ومن أن المؤقت قد انتهى
    if (!isActive || _otpTimeRemaining > 0) return;

    emit(OtpLoading());

    if (sendOtpUseCase != null) {
      final result = await sendOtpUseCase!(email);

      // التحقق مرة أخرى من أن الكيوبت لم يتم التخلص منه قبل إرسال الحدث
      if (!isActive) return;

      result.fold(
        (failure) => emit(
          OtpError(
            message: failure.errorMessage?.message ?? 'Unknown error occurred',
          ),
        ),
        (_) {
          _startOtpTimer();
          emit(OtpResent());
        },
      );
    } else {
      // Mock implementation for development
      await Future.delayed(Duration(seconds: 1));

      // التحقق مرة أخرى من أن الكيوبت لم يتم التخلص منه قبل إرسال الحدث
      if (!isActive) return;

      _startOtpTimer();
      emit(OtpResent());
    }
  }

  // إلغاء المؤقت دون تغيير الحالة (لاستخدامه في dispose)
  void cancelTimer() {
    _otpTimer?.cancel();
    _otpTimer = null;
  }

  // إلغاء المؤقت
  void _cancelTimer() {
    _otpTimer?.cancel();
    _otpTimer = null;
  }

  @override
  Future<void> close() {
    _cancelTimer();

    // تعيين علامة التخلص
    _isDisposed = true;

    return super.close();
  }
}