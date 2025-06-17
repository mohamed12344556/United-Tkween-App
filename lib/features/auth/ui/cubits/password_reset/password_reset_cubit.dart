import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utilities/safe_controller.dart';
import '../../../domain/entities/user_reset_password_entity.dart';
import '../../../domain/usecases/auth_usecases.dart';

import '../../../../../core/core.dart';

part 'password_reset_state.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  // Use cases
  final ResetPasswordUseCase? resetPasswordUseCase;

  // Controllers
  late final SafeTextEditingController emailController;
  late final SafeTextEditingController passwordController;
  late final SafeTextEditingController confirmPasswordController;

  // Current email being processed
  String? currentEmail;

  // متغير للتحقق من حالة التخلص من وحدات التحكم
  bool _isDisposed = false;

  // Password visibility toggles
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  PasswordResetCubit({
    this.resetPasswordUseCase,
  }) : super(PasswordResetInitial()) {
    // إنشاء وحدات التحكم الآمنة في البناء
    emailController = SafeTextEditingController();
    passwordController = SafeTextEditingController();
    confirmPasswordController = SafeTextEditingController();
  }

  // التحقق من أن وحدات التحكم ما زالت نشطة
  bool get isActive => !_isDisposed;

  // دوال إضافية للتعامل مع التنقل بين الشاشات
  void setEmail(String email) {
    currentEmail = email;
    if (!emailController.isDisposed) {
      emailController.text = email;
    }
  }

  // Reset password
  Future<void> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    try {
      // تحقق من صحة المدخلات
      if (password.isEmpty) {
        emit(PasswordResetError(message: context.localeS.password_is_required));
        return;
      }

      if (confirmPassword.isEmpty) {
        emit(
          PasswordResetError(
            message: context.localeS.confirm_password_is_required,
          ),
        );
        return;
      }

      if (password != confirmPassword) {
        emit(
          PasswordResetError(message: context.localeS.passwords_do_not_match),
        );
        return;
      }

      if (password.length < 6) {
        emit(
          PasswordResetError(
            message:
                context.localeS.password_must_be_at_least_6_characters_long,
          ),
        );
        return;
      }

      // التحقق من أن الكيوبت لا يزال نشطاً
      if (!isActive) return;

      emit(PasswordResetLoading());

      final resetEntity = UserResetPasswordEntity(
        email: email,
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
            PasswordResetError(
              message:
                  failure.errorMessage?? 'Unknown error occurred',
            ),
          ),
          (_) => emit(PasswordResetSuccess()),
        );
      } else {
        // نسخة محاكاة للتطوير
        await Future.delayed(Duration(seconds: 1));

        // تحقق مرة أخرى من النشاط بعد التأخير
        if (!isActive) return;

        emit(PasswordResetSuccess());
      }
    } catch (e) {
      if (isActive) {
        emit(PasswordResetError(message: e.toString()));
      }
    }
  }

  // إعادة ضبط الحالة إلى الحالة الأولية
  void resetState() {
    if (!isActive) return;

    // حذف المحتوى الآمن باستخدام SafeTextEditingController
    if (!emailController.isDisposed) emailController.clear();
    if (!passwordController.isDisposed) passwordController.clear();
    if (!confirmPasswordController.isDisposed) {
      confirmPasswordController.clear();
    }

    emit(PasswordResetInitial());
  }

  // تبديل إظهار كلمة المرور
  void togglePasswordVisibility() {
    if (!isActive) return;
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordResetFormUpdated());
  }

  // تبديل إظهار تأكيد كلمة المرور
  void toggleConfirmPasswordVisibility() {
    if (!isActive) return;
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(PasswordResetFormUpdated());
  }

  @override
  Future<void> close() {
    // تعيين علامة التخلص قبل التخلص من وحدات التحكم
    _isDisposed = true;

    // التخلص من وحدات التحكم بشكل آمن
    try {
      if (!emailController.isDisposed) {
        emailController.dispose();
      }

      if (!passwordController.isDisposed) {
        passwordController.dispose();
      }

      if (!confirmPasswordController.isDisposed) {
        confirmPasswordController.dispose();
      }
    } catch (e) {
      print('Error disposing controllers: $e');
    }

    return super.close();
  }
}