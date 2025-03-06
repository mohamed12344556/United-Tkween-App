import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  // Controllers for form fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Password visibility flag
  bool isPasswordVisible = false;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(RegisterFormUpdated());
  }

  // Register user with email and password
  Future<void> registerWithEmailAndPassword() async {
    try {
      // Get form values
      final email = emailController.text.trim();
      final password = passwordController.text;

      // Validate inputs
      if (email.isEmpty) {
        emit(RegisterError(errorMessage: LocaleKeys.email_is_required.tr()));
        return;
      }

      if (password.isEmpty) {
        emit(RegisterError(errorMessage: LocaleKeys.password_is_required.tr()));
        return;
      }

      // Simple email validation
      if (!email.contains('@') || !email.contains('.')) {
        emit(
          RegisterError(errorMessage: LocaleKeys.invalid_email_address.tr()),
        );
        return;
      }

      // Password validation
      if (password.length < 6) {
        emit(
          RegisterError(
            errorMessage:
                LocaleKeys.password_must_be_at_least_6_characters_long.tr(),
          ),
        );
        return;
      }

      // Show loading state
      emit(RegisterLoading());

      // Simulate API call for registration
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual registration API call
      // For example:
      // final result = await authRepository.register(email, password);
      await requestVerificationOtp(email);
      // Emit success state with email for OTP verification
      emit(RegisterSuccess(userID: 'user_123', userEmail: email));
    } catch (e) {
      // Handle registration errors
      emit(
        RegisterError(
          errorMessage: LocaleKeys.something_went_wrong_please_try_again.tr(),
        ),
      );
    }
  }

  // Register with social media
  Future<void> registerWithSocialMedia(String provider) async {
    try {
      emit(RegisterLoading());

      // Simulate API call for social login
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual social login
      // final result = await authRepository.loginWithSocial(provider);

      // For social logins, we might still need email verification or directly proceed
      // Here we're assuming we got the email from social provider
      final socialEmail = 'social@example.com';

      emit(
        RegisterSuccess(
          userID: 'social_user_123',
          userEmail: socialEmail,
          socialProvider: provider,
        ),
      );
    } catch (e) {
      emit(
        RegisterError(
          errorMessage: LocaleKeys.something_went_wrong_please_try_again.tr(),
        ),
      );
    }
  }

  Future<void> requestVerificationOtp(String email) async {
    try {
      emit(RegisterLoading());

      // هنا يجب الاتصال بـ API لطلب إرسال OTP
      // لأغراض التطوير، سنقوم بمحاكاة طلب OTP
      await Future.delayed(const Duration(seconds: 1));

      // إرسال النجاح
      emit(RegisterOtpSent(email: email));
    } catch (e) {
      emit(
        RegisterError(
          errorMessage: LocaleKeys.something_went_wrong_please_try_again.tr(),
        ),
      );
    }
  }

  // Reset registration form
  void resetForm() {
    emailController.clear();
    passwordController.clear();
    isPasswordVisible = false;
    emit(RegisterInitial());
  }

  @override
  Future<void> close() {
    // Clean up controllers
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}