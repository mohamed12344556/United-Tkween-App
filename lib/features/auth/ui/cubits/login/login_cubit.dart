import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:united_formation_app/features/auth/domain/entities/user_login_entity.dart';
import 'package:united_formation_app/features/auth/domain/usecases/auth_usecases.dart';

import 'package:united_formation_app/generated/locale_keys.g.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase? loginUseCase;

  bool _isDisposed = false;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  set isPasswordVisible(bool value) {
    if (!isActive) return;

    _isPasswordVisible = value;
  }

  bool get isActive => !_isDisposed;

  LoginCubit({this.loginUseCase}) : super(LoginInitial()) {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> login({required String email, required String password}) async {
    try {
      if (!isActive) return;

      // Validate inputs
      if (email.isEmpty) {
        emit(LoginError(errorMessage: LocaleKeys.email_is_required.tr()));
        return;
      }

      if (password.isEmpty) {
        emit(LoginError(errorMessage: LocaleKeys.password_is_required.tr()));
        return;
      }

      if (!email.contains('@') || !email.contains('.')) {
        emit(LoginError(errorMessage: LocaleKeys.invalid_email_address.tr()));
        return;
      }

      emit(LoginLoading());

      // Use actual login UseCase if available
      if (loginUseCase != null) {
        final result = await loginUseCase!(
          UserLoginEntity(email: email, password: password),
        );

        if (!isActive) return;

        result.fold(
          (failure) => emit(
            LoginError(
              errorMessage:
                  failure.errorMessage?.message ??
                  LocaleKeys.something_went_wrong_please_try_again.tr(),
            ),
          ),
          (_) => emit(
            LoginSuccess(
              userID: 'user_123', // Assuming these would come from API
              userToken: 'token_123',
            ),
          ),
        );
      } else {
        // Mock implementation for development
        await Future.delayed(const Duration(seconds: 2));

        if (!isActive) return;

        // Check credentials (this is just a mock)
        if (email == 'test@example.com' && password == 'password123') {
          // Successful login
          emit(LoginSuccess(userID: '12345', userToken: 'mock_token_value'));
        } else {
          // Failed login
          emit(LoginError(errorMessage: LocaleKeys.invalid_email_address.tr()));
        }
      }
    } catch (e) {
      if (isActive) {
        emit(
          LoginError(
            errorMessage: LocaleKeys.something_went_wrong_please_try_again.tr(),
          ),
        );
      }
    }
  }

  void togglePasswordVisibility() {
    if (!isActive) return;
    isPasswordVisible = !isPasswordVisible;
    emit(LoginFormUpdated());
  }

  void resetState() {
    if (!isActive) return;
    emit(LoginInitial());
  }

  @override
  Future<void> close() {
    _isDisposed = true;
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
