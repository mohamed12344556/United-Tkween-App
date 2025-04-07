import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_register_entity.dart';
import '../../../domain/usecases/auth_usecases.dart';
import '../../../../../core/utilities/safe_controller.dart';

import '../../../../../core/core.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  bool _isDisposed = false;

  // وحدات التحكم في حقول النموذج
  late final SafeTextEditingController nameController;
  late final SafeTextEditingController emailController;
  late final SafeTextEditingController phoneController;
  late final SafeTextEditingController passwordController;
  late final SafeTextEditingController addressController;

  // حالة رؤية كلمة المرور
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  // التحقق من حالة الـ Cubit
  bool get isActive => !_isDisposed;

  RegisterCubit({required this.registerUseCase}) : super(RegisterInitial()) {
    nameController = SafeTextEditingController();
    emailController = SafeTextEditingController();
    phoneController = SafeTextEditingController();
    passwordController = SafeTextEditingController();
    addressController = SafeTextEditingController();
  }

  // تبديل حالة رؤية كلمة المرور
  void togglePasswordVisibility() {
    if (!isActive) return;
    _isPasswordVisible = !_isPasswordVisible;
    emit(RegisterFormUpdated());
  }

  // التحقق من صحة البريد الإلكتروني
  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegExp.hasMatch(email);
  }

  // تسجيل مستخدم جديد
  Future<void> register(BuildContext context) async {
    try {
      if (!isActive) return;

      // الحصول على قيم النموذج
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final phone = phoneController.text?.trim() ?? "1111111";
      final password = passwordController.text;
      final address = addressController.text?.trim() ?? "for testing";

      // التحقق من المدخلات
      if (name.isEmpty) {
        emit(RegisterError(errorMessage: context.localeS.name_is_required));
        return;
      }

      if (email.isEmpty) {
        emit(RegisterError(errorMessage: context.localeS.email_is_required));
        return;
      }
      // if (!Platform.isIOS) {
      //   if (phone.isEmpty) {
      //     emit(RegisterError(errorMessage: context.localeS.phone_is_required));
      //     return;
      //   }
      // }

      if (password.isEmpty) {
        emit(RegisterError(errorMessage: context.localeS.password_is_required));
        return;
      }

      // if (!Platform.isIOS) {
      //   if (address.isEmpty) {
      //     emit(
      //       RegisterError(errorMessage: context.localeS.address_is_required),
      //     );
      //     return;
      //   }
      // }

      // التحقق من صحة البريد الإلكتروني
      if (!_isValidEmail(email)) {
        emit(
          RegisterError(errorMessage: context.localeS.invalid_email_address),
        );
        return;
      }

      // التحقق من صحة كلمة المرور
      if (password.length < 6) {
        emit(
          RegisterError(
            errorMessage:
                context.localeS.password_must_be_at_least_6_characters_long,
          ),
        );
        return;
      }

      emit(RegisterLoading());
      // تعيين القيم الافتراضية للعنوان ورقم الهاتف عند الحاجة
      final defaultPhone = "1111111";
      final defaultAddress = "Default Address";

      // إنشاء كيان التسجيل
      final registerEntity = UserRegisterEntity(
        fullName: name,
        email: email,
        phoneNumber: phone.isEmpty ? defaultPhone : phone,
        password: password,
        address: address.isEmpty ? defaultAddress : address,
      );

      // استدعاء حالة الاستخدام للتسجيل
      final result = await registerUseCase(registerEntity);

      if (!isActive) return;

      result.fold(
        (failure) => emit(
          RegisterError(
            errorMessage:
                failure.errorMessage ??
                context.localeS.something_went_wrong_please_try_again,
          ),
        ),
        (response) async {
          // التحقق من استجابة التسجيل
          if (response.status == 'success') {
            // تحويل مباشر إلى صفحة النجاح بدون OTP
            emit(RegisterSuccess(userEmail: email));
          } else {
            emit(RegisterError(errorMessage: response.message));
          }
        },
      );
    } catch (e) {
      debugPrint('Register error: $e');
      if (isActive) {
        emit(
          RegisterError(
            errorMessage: context.localeS.something_went_wrong_please_try_again,
          ),
        );
      }
    }
  }

  // تسجيل باستخدام وسائل التواصل الاجتماعي
  Future<void> registerWithSocialMedia(
    String provider,
    String email,
    String name,
    String token,
    BuildContext context,
  ) async {
    // هنا يمكنك إضافة منطق التسجيل عبر وسائل التواصل الاجتماعي
    // يمكن استخدام نفس RegisterUseCase أو إنشاء UseCase خاص
    debugPrint(
      'Social sign-in with $provider: $email, $name, token: ${token.substring(0, 10)}...',
    );

    // لتبسيط الأمور، نقوم بإرسال حالة النجاح مباشرة
    emit(RegisterSuccess(userEmail: email));
  }

  // إعادة تعيين نموذج التسجيل
  void resetForm() {
    if (!isActive) return;

    if (!nameController.isDisposed) nameController.clear();
    if (!emailController.isDisposed) emailController.clear();
    if (!phoneController.isDisposed) phoneController.clear();
    if (!passwordController.isDisposed) passwordController.clear();
    if (!addressController.isDisposed) addressController.clear();

    _isPasswordVisible = false;
    emit(RegisterInitial());
  }

  @override
  Future<void> close() {
    _isDisposed = true;

    // التخلص الآمن من وحدات التحكم
    try {
      if (!nameController.isDisposed) nameController.dispose();
      if (!emailController.isDisposed) emailController.dispose();
      if (!phoneController.isDisposed) phoneController.dispose();
      if (!passwordController.isDisposed) passwordController.dispose();
      if (!addressController.isDisposed) addressController.dispose();
    } catch (e) {
      debugPrint('Error disposing controllers: $e');
    }

    return super.close();
  }
}
