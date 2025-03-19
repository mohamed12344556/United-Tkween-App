import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/auth/data/models/login/login_model_response.dart';
import '../../../../../core/core.dart';
import '../../../../../core/utilities/safe_controller.dart';
import '../../../domain/entities/user_login_entity.dart';
import '../../../domain/usecases/auth_usecases.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  // متغير لمراقبة حالة الـ Cubit (مستخدم أم تم التخلص منه)
  bool _isDisposed = false;

  // تحكم في حقول الإدخال
  late final SafeTextEditingController emailController;
  late final SafeTextEditingController passwordController;

  // متغير للتحكم في رؤية كلمة المرور
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  // متغير للتحقق من حالة الـ Cubit
  bool get isActive => !_isDisposed;

  LoginCubit({required this.loginUseCase}) : super(LoginInitial()) {
    emailController = SafeTextEditingController();
    passwordController = SafeTextEditingController();
  }

  /// تبديل حالة رؤية كلمة المرور
  void togglePasswordVisibility() {
    if (!isActive) return;
    _isPasswordVisible = !_isPasswordVisible;
    emit(LoginFormUpdated());
  }

  /// إعادة تعيين حالة الـ Cubit
  void resetState() {
    if (!isActive) return;
    
    emailController.clear();
    passwordController.clear();
    
    _isPasswordVisible = false;
    emit(LoginInitial());
  }

  /// التحقق من صحة البريد الإلكتروني
  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegExp.hasMatch(email);
  }

  /// تسجيل الدخول
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (!isActive) return;

    try {
      // التحقق من البيانات المدخلة
      if (email.isEmpty) {
        emit(LoginError(errorMessage: context.localeS.email_is_required));
        return;
      }

      if (password.isEmpty) {
        emit(LoginError(errorMessage: context.localeS.password_is_required));
        return;
      }

      if (!_isValidEmail(email)) {
        emit(LoginError(errorMessage: context.localeS.invalid_email_address));
        return;
      }

      emit(LoginLoading());

      // استدعاء حالة الاستخدام للتسجيل
      final result = await loginUseCase(
        UserLoginEntity(email: email, password: password),
      );

      if (!isActive) return;

      result.fold(
        (failure) {
          // معالجة حالة الفشل
          emit(LoginError(
            errorMessage: failure.errorMessage ?? 
                context.localeS.something_went_wrong_please_try_again,
          ));
        },
        (loginResponse) {
          // معالجة حالة النجاح
          debugPrint("Login successful: ${loginResponse.token}");
          
          // التحقق من صحة البيانات المُرجعة
          if (loginResponse.token.isEmpty) {
            emit(LoginError(
              errorMessage: context.localeS.something_went_wrong_please_try_again,
            ));
            return;
          }
          
          // إرسال حالة النجاح
          emit(LoginSuccess(loginModelResponse: loginResponse));
        },
      );
    } catch (e, stackTrace) {
      debugPrint("Login error: $e");
      debugPrint("Stack trace: $stackTrace");
      
      if (isActive) {
        emit(LoginError(
          errorMessage: context.localeS.something_went_wrong_please_try_again,
        ));
      }
    }
  }

  @override
  Future<void> close() {
    _isDisposed = true;
    
    if (!emailController.isDisposed) {
      emailController.dispose();
    }
    
    if (!passwordController.isDisposed) {
      passwordController.dispose();
    }
    
    return super.close();
  }
}