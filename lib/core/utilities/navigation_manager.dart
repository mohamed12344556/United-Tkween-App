import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/routes/routes.dart';
import 'package:united_formation_app/core/api/auth_interceptor.dart';
import 'package:united_formation_app/features/auth/ui/cubits/otp/otp_cubit.dart';
import 'package:united_formation_app/features/auth/ui/cubits/password_reset/password_reset_cubit.dart';

class NavigationManager {
  // استخدام NavigationService.navigatorKey الموجود في المشروع
  static final GlobalKey<NavigatorState> _navigatorKey = NavigationService.navigatorKey;
  
  // الحصول على سياق التنقل الحالي
  static BuildContext? get _currentContext => _navigatorKey.currentContext;
  
  // التنقل إلى صفحة تسجيل الدخول مع إعادة تعيين التراكم
  static void navigateToLogin({bool resetStack = true}) {
    final context = _currentContext;
    if (context == null) return;
    
    // إلغاء أي cubits نشطة قبل التنقل
    _disposeAuthCubits(context);
    
    // نقوم بعملية التنقل
    if (resetStack) {
      _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.loginView,
        (route) => false,
      );
    } else {
      _navigatorKey.currentState?.pushReplacementNamed(Routes.loginView);
    }
  }
  
  // التنقل إلى صفحة التحقق من OTP
  static void navigateToOtpVerification(
    String email, 
    {bool isPasswordReset = false}
  ) {
    if (isPasswordReset) {
      _navigatorKey.currentState?.pushNamed(
        Routes.verifyOtpView,
        arguments: {'email': email, 'isPasswordReset': true},
      );
    } else {
      _navigatorKey.currentState?.pushNamed(
        Routes.verifyOtpView,
        arguments: email,
      );
    }
  }
  
  // التنقل إلى صفحة إعادة تعيين كلمة المرور
  static void navigateToResetPassword(
    String email, 
    String otp
  ) {
    // نستخدم pushReplacement لتجنب تراكم الصفحات
    _navigatorKey.currentState?.pushReplacementNamed(
      Routes.resetPasswordView,
      arguments: {'email': email, 'otp': otp},
    );
  }
  
  // التنقل إلى الصفحة الرئيسية بعد نجاح تسجيل الدخول
  static void navigateToHome() {
    final context = _currentContext;
    if (context == null) return;
    
    // تأكد من إلغاء جميع cubits المتعلقة بالمصادقة
    _disposeAuthCubits(context);
    
    _navigatorKey.currentState?.pushNamedAndRemoveUntil(
      Routes.homeView,
      (route) => false,
    );
  }
  
  // التنقل إلى صفحة خيارات التعلم بعد التحقق من OTP
  static void navigateToLearningOptions() {
    final context = _currentContext;
    if (context == null) return;
    
    // تأكد من إلغاء مؤقتات OTP
    try {
      final otpCubit = BlocProvider.of<OtpCubit>(context, listen: false);
      otpCubit.cancelTimer();
    } catch (e) {
      print('Error cancelling OTP timer: $e');
    }
    
    _navigatorKey.currentState?.pushNamedAndRemoveUntil(
      Routes.learningOptionsView,
      (route) => false,
    );
  }
  
  // دالة مساعدة للتخلص من cubits المصادقة
  static void _disposeAuthCubits(BuildContext context) {
    try {
      // نحاول إلغاء المؤقتات في cubits المختلفة
      try {
        final otpCubit = BlocProvider.of<OtpCubit>(context, listen: false);
        otpCubit.cancelTimer();
      } catch (e) {
        // OtpCubit غير متوفر
      }
      
      try {
        final passwordResetCubit = BlocProvider.of<PasswordResetCubit>(context, listen: false);
        passwordResetCubit.cancelTimer();
      } catch (e) {
        // PasswordResetCubit غير متوفر
      }
      
    } catch (e) {
      print('Error disposing auth cubits: $e');
    }
  }
}