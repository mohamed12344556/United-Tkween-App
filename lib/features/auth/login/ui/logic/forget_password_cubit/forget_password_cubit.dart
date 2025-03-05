import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:united_formation_app/features/auth/login/domain/entities/user_reset_password_entity.dart';
import 'package:united_formation_app/features/auth/login/domain/usecases/reset_password_use_case.dart';
import 'package:united_formation_app/features/auth/login/domain/usecases/sent_otp_use_case.dart';
import 'package:united_formation_app/features/auth/login/domain/usecases/verify_otp_use_case.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  // Use cases
  final SendOtpUseCase? sendOtpUseCase;
  final VerifyOtpUseCase? verifyOtpUseCase;
  final ResetPasswordUseCase? resetPasswordUseCase;

  // Controllers
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  // Current email being processed
  String? currentEmail;
  String? verifiedOtp;

  // متغير للتحقق من حالة التخلص من وحدات التحكم
  bool _isDisposed = false;

  // Password visibility toggles
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // OTP Timer
  Timer? _otpTimer;
  int _otpTimeRemaining = 60; // 60 seconds timeout
  int get otpTimeRemaining => _otpTimeRemaining;

  ForgetPasswordCubit({
    this.sendOtpUseCase,
    this.verifyOtpUseCase,
    this.resetPasswordUseCase,
  }) : super(ForgetPasswordInitial()) {
    // إنشاء وحدات التحكم في البناء
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  // التحقق من أن وحدات التحكم ما زالت نشطة
  bool get isActive => !_isDisposed;

  // دوال إضافية للتعامل مع التنقل بين الشاشات
  void setEmail(String email) {
    currentEmail = email;
    emailController.text = email;
  }

  void setVerifiedOtp(String otp) {
    verifiedOtp = otp;
  }

  // Request OTP to be sent to email
  Future<void> requestOtp({required String email}) async {
    try {
      // تحقق من صحة البريد الإلكتروني أولاً
      if (email.isEmpty) {
        emit(ForgetPasswordError(message: LocaleKeys.email_is_required.tr()));
        return;
      }

      if (!email.contains('@') || !email.contains('.')) {
        emit(
          ForgetPasswordError(message: LocaleKeys.invalid_email_address.tr()),
        );
        return;
      }

      // التحقق من أن الكيوبت لا يزال نشطًا
      if (!isActive) return;

      emit(ForgetPasswordLoading());

      // استخدام حالة الاستخدام إذا كانت متوفرة، أو المحاكاة للتطوير
      if (sendOtpUseCase != null) {
        final result = await sendOtpUseCase!(email);
        
        // تحقق مرة أخرى من النشاط بعد العملية غير المتزامنة
        if (!isActive) return;
        
        result.fold(
          (failure) => emit(
            ForgetPasswordError(
              message:
                  failure.errorMessage?.message ?? 'Unknown error occurred',
            ),
          ),
          (_) {
            currentEmail = email;
            emit(ForgetPasswordOtpSent(email: email));
            _startOtpTimer();
          },
        );
      } else {
        // نسخة محاكاة للتطوير
        await Future.delayed(Duration(seconds: 1));
        
        // تحقق مرة أخرى من النشاط بعد التأخير
        if (!isActive) return;
        
        currentEmail = email;
        emit(ForgetPasswordOtpSent(email: email));
        _startOtpTimer();
      }
    } catch (e) {
      if (isActive) {
        emit(ForgetPasswordError(message: e.toString()));
      }
    }
  }

  // Verify OTP code
  Future<void> verifyOtp({required String otp, required String email}) async {
    try {
      // تحقق من صحة OTP
      if (otp.isEmpty || otp.length < 4) {
        emit(
          ForgetPasswordError(message: LocaleKeys.please_enter_valid_otp.tr()),
        );
        return;
      }

      // التحقق من أن الكيوبت لا يزال نشطاً
      if (!isActive) return;

      emit(ForgetPasswordLoading());

      // استخدام حالة الاستخدام إذا كانت متوفرة، أو المحاكاة للتطوير
      if (verifyOtpUseCase != null) {
        final result = await verifyOtpUseCase!(
          VerifyOtpParams(otp: otp, email: email),
        );
        
        // تحقق مرة أخرى من النشاط بعد العملية غير المتزامنة
        if (!isActive) return;
        
        result.fold(
          (failure) => emit(
            ForgetPasswordError(
              message:
                  failure.errorMessage?.message ?? 'Unknown error occurred',
            ),
          ),
          (_) {
            // إلغاء المؤقت قبل إرسال حالة النجاح
            _cancelTimer();
            verifiedOtp = otp;
            emit(ForgetPasswordOtpVerified(email: email));
          },
        );
      } else {
        // نسخة محاكاة للتطوير
        await Future.delayed(Duration(seconds: 1));
        
        // تحقق مرة أخرى من النشاط بعد التأخير
        if (!isActive) return;
        
        // إلغاء المؤقت قبل إرسال حالة النجاح
        _cancelTimer();
        verifiedOtp = otp;
        emit(ForgetPasswordOtpVerified(email: email));
      }
    } catch (e) {
      if (isActive) {
        emit(ForgetPasswordError(message: e.toString()));
      }
    }
  }

  // Reset password
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      // تحقق من صحة المدخلات
      if (password.isEmpty) {
        emit(
          ForgetPasswordError(message: LocaleKeys.password_is_required.tr()),
        );
        return;
      }

      if (confirmPassword.isEmpty) {
        emit(
          ForgetPasswordError(
            message: LocaleKeys.confirm_password_is_required.tr(),
          ),
        );
        return;
      }

      if (password != confirmPassword) {
        emit(
          ForgetPasswordError(message: LocaleKeys.passwords_do_not_match.tr()),
        );
        return;
      }

      if (password.length < 6) {
        emit(
          ForgetPasswordError(
            message:
                LocaleKeys.password_must_be_at_least_6_characters_long.tr(),
          ),
        );
        return;
      }

      // التحقق من أن الكيوبت لا يزال نشطاً
      if (!isActive) return;

      emit(ForgetPasswordLoading());

      final resetEntity = UserResetPasswordEntity(
        email: email,
        resetToken: otp,
        password: password,
        passwordConfirmation: confirmPassword,
      );

      // استخدام حالة الاستخدام إذا كانت متوفرة، أو المحاكاة للتطوير
      if (resetPasswordUseCase != null) {
        final result = await resetPasswordUseCase!(resetEntity);
        
        // تحقق مرة أخرى من النشاط بعد العملية غير المتزامنة
        if (!isActive) return;
        
        result.fold(
          (failure) => emit(
            ForgetPasswordError(
              message:
                  failure.errorMessage?.message ?? 'Unknown error occurred',
            ),
          ),
          (_) => emit(ForgetPasswordSuccess()),
        );
      } else {
        // نسخة محاكاة للتطوير
        await Future.delayed(Duration(seconds: 1));
        
        // تحقق مرة أخرى من النشاط بعد التأخير
        if (!isActive) return;
        
        emit(ForgetPasswordSuccess());
      }
    } catch (e) {
      if (isActive) {
        emit(ForgetPasswordError(message: e.toString()));
      }
    }
  }

  // إعادة ضبط الحالة إلى الحالة الأولية
  void resetState() {
    if (!isActive) return;
    emit(ForgetPasswordInitial());
  }

  // تبديل إظهار كلمة المرور
  void togglePasswordVisibility() {
    if (!isActive) return;
    isPasswordVisible = !isPasswordVisible;
    emit(ForgetPasswordFormUpdated());
  }

  // تبديل إظهار تأكيد كلمة المرور
  void toggleConfirmPasswordVisibility() {
    if (!isActive) return;
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(ForgetPasswordFormUpdated());
  }

  // بدء مؤقت OTP
  void _startOtpTimer() {
    _cancelTimer();
    _otpTimeRemaining = 60;
    _otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_otpTimeRemaining > 0) {
        _otpTimeRemaining--;
        if (isActive) {
          emit(
            ForgetPasswordOtpTimerUpdated(
              timeRemaining: _otpTimeRemaining,
              email: currentEmail!,
            ),
          );
        }
      } else {
        _cancelTimer();
      }
    });
  }

  // إعادة إرسال OTP
  Future<void> resendOtp() async {
    if (currentEmail != null && _otpTimeRemaining <= 0) {
      await requestOtp(email: currentEmail!);
      if (isActive) {
        emit(ForgetPasswordOtpResent());
      }
    }
  }

  void startTimer() {
    if (_otpTimeRemaining <= 0) {
      _startOtpTimer();
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

    // تعيين علامة التخلص قبل التخلص من وحدات التحكم
    _isDisposed = true;

    // التخلص من وحدات التحكم
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    return super.close();
  }
}