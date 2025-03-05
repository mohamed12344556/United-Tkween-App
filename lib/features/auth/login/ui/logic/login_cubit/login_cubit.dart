import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  // متغير لتتبع حالة التخلص من الكيوبت
  bool _isDisposed = false;
  
  // وحدات التحكم
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  // Moved to be a property with getter/setter to trigger UI updates
  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  set isPasswordVisible(bool value) {
    // تحقق من أن الكيوبت لم يتم التخلص منه
    if (!isActive) return;
    
    _isPasswordVisible = value;
    // We can emit a state change here if we want the entire UI to rebuild
    // or we can just let setState handle the visibility toggle locally
  }
  
  // دالة للتحقق من أن الكيوبت لا يزال نشطًا
  bool get isActive => !_isDisposed;

  LoginCubit() : super(LoginInitial()) {
    // تهيئة وحدات التحكم في البناء
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  // Method to handle login process
  Future<void> login({required String email, required String password}) async {
    try {
      // التحقق من أن الكيوبت لا يزال نشطًا
      if (!isActive) return;
      
      // Emit loading state first
      emit(LoginLoading());

      // Validate inputs
      if (email.isEmpty) {
        emit(LoginError(errorMessage: LocaleKeys.email_is_required.tr()));
        return;
      }

      if (password.isEmpty) {
        emit(
          LoginError(errorMessage: LocaleKeys.password_is_required.tr()),
        );
        return;
      }

      // Email validation
      if (!email.contains('@') || !email.contains('.')) {
        emit(LoginError(errorMessage: LocaleKeys.invalid_email_address.tr()));
        return;
      }

      // TODO: Implement actual API call for authentication
      // This is a placeholder for the actual API call
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay

      // التحقق مرة أخرى من أن الكيوبت لا يزال نشطًا بعد انتظار الشبكة
      if (!isActive) return;

      // Check credentials (this is just a mock)
      if (email == 'test@example.com' && password == 'password123') {
        // Successful login
        emit(LoginSuccess(userID: '12345', userToken: 'mock_token_value'));
      } else {
        // Failed login
        emit(LoginError(errorMessage: LocaleKeys.invalid_email_address.tr()));
      }
    } catch (e) {
      // التحقق من أن الكيوبت لا يزال نشطًا قبل إرسال الخطأ
      if (isActive) {
        // Handle any exceptions
        emit(
          LoginError(
            errorMessage: LocaleKeys.something_went_wrong_please_try_again.tr(),
          ),
        );
      }
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    if (!isActive) return;
    isPasswordVisible = !isPasswordVisible;
  }

  // Method to reset the login state
  void resetState() {
    if (!isActive) return;
    emit(LoginInitial());
  }

  @override
  Future<void> close() {
    // تعيين علامة التخلص أولاً
    _isDisposed = true;
    
    // التخلص من وحدات التحكم
    emailController.dispose();
    passwordController.dispose();
    
    return super.close();
  }
}