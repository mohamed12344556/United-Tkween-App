import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_login_entity.dart';
import 'package:united_formation_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:united_formation_app/core/utilities/safe_controller.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

import '../../../../../core/core.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase? registerUseCase;
  final SendOtpUseCase? sendOtpUseCase;

  bool _isDisposed = false;

  // Controllers for form fields
  late final SafeTextEditingController emailController;
  late final SafeTextEditingController passwordController;

  // Password visibility flag
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  // Check if cubit is still active
  bool get isActive => !_isDisposed;

  RegisterCubit({this.registerUseCase, this.sendOtpUseCase})
    : super(RegisterInitial()) {
    emailController = SafeTextEditingController();
    passwordController = SafeTextEditingController();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    if (!isActive) return;
    _isPasswordVisible = !_isPasswordVisible;
    emit(RegisterFormUpdated());
  }

  // Register user with email and password
  Future<void> registerWithEmailAndPassword() async {
    try {
      if (!isActive) return;

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

      // Use actual register UseCase if available
      if (registerUseCase != null) {
        final result = await registerUseCase!(
          UserLoginEntity(email: email, password: password),
        );

        if (!isActive) return;

        result.fold(
          (failure) => emit(
            RegisterError(
              errorMessage:
                  failure.errorMessage?.message ??
                  LocaleKeys.something_went_wrong_please_try_again.tr(),
            ),
          ),
          (_) async {
            // Request OTP verification after successful registration
            await requestVerificationOtp(email);
          },
        );
      } else {
        // Mock implementation for development
        await Future.delayed(const Duration(seconds: 2));

        if (!isActive) return;

        // Request verification OTP
        await requestVerificationOtp(email);
      }
    } catch (e) {
      if (isActive) {
        emit(
          RegisterError(
            errorMessage: LocaleKeys.something_went_wrong_please_try_again.tr(),
          ),
        );
      }
    }
  }

  // Register with social media
  Future<void> registerWithSocialMedia(String provider) async {
    try {
      if (!isActive) return;

      emit(RegisterLoading());

      // Simulate API call for social login
      await Future.delayed(const Duration(seconds: 2));

      if (!isActive) return;

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
      if (isActive) {
        emit(
          RegisterError(
            errorMessage: LocaleKeys.something_went_wrong_please_try_again.tr(),
          ),
        );
      }
    }
  }

  Future<void> requestVerificationOtp(String email) async {
    try {
      if (!isActive) return;

      emit(RegisterLoading());

      // Use actual sendOtp UseCase if available
      if (sendOtpUseCase != null) {
        final result = await sendOtpUseCase!(
          SendOtpParams(email: email, purpose: OtpPurpose.accountVerification),
        );

        if (!isActive) return;

        result.fold(
          (failure) => emit(
            RegisterError(
              errorMessage:
                  failure.errorMessage?.message ??
                  LocaleKeys.something_went_wrong_please_try_again.tr(),
            ),
          ),
          (_) => emit(RegisterOtpSent(email: email)),
        );
      } else {
        // Mock implementation for development
        await Future.delayed(const Duration(seconds: 1));

        if (!isActive) return;

        // Success state
        emit(RegisterOtpSent(email: email));
      }
    } catch (e) {
      if (isActive) {
        emit(
          RegisterError(
            errorMessage: LocaleKeys.something_went_wrong_please_try_again.tr(),
          ),
        );
      }
    }
  }

  // Reset registration form
  void resetForm() {
    if (!isActive) return;

    // استخدام isDisposed مع SafeTextEditingController
    if (!emailController.isDisposed) emailController.clear();
    if (!passwordController.isDisposed) passwordController.clear();
    
    _isPasswordVisible = false;
    emit(RegisterInitial());
  }

  @override
  Future<void> close() {
    _isDisposed = true;

    // التخلص الآمن من وحدات التحكم
    try {
      if (!emailController.isDisposed) {
        emailController.dispose();
      }
      if (!passwordController.isDisposed) {
        passwordController.dispose();
      }
    } catch (e) {
      print('Error disposing controllers: $e');
    }
    
    return super.close();
  }
}