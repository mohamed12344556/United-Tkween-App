import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/core.dart';
import '../../../../../core/utilities/safe_controller.dart';
import '../../../domain/entities/user_login_entity.dart';
import '../../../domain/usecases/auth_usecases.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase? loginUseCase;

  bool _isDisposed = false;

  late final SafeTextEditingController emailController;
  late final SafeTextEditingController passwordController;

  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  set isPasswordVisible(bool value) {
    if (!isActive) return;

    _isPasswordVisible = value;
  }

  bool get isActive => !_isDisposed;

  LoginCubit({this.loginUseCase}) : super(LoginInitial()) {
    emailController = SafeTextEditingController();
    passwordController = SafeTextEditingController();
  }

  Future<void> login({required String email, required String password, required BuildContext context}) async {
    try {
      if (!isActive) return;

      // Validate inputs
      if (email.isEmpty) {
        emit(LoginError(errorMessage: context.localeS.email_is_required));
        return;
      }

      if (password.isEmpty) {
        emit(LoginError(errorMessage: context.localeS.password_is_required));
        return;
      }

      if (!email.contains('@') || !email.contains('.')) {
        emit(LoginError(errorMessage: context.localeS.invalid_email_address));
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
                  context.localeS.something_went_wrong_please_try_again,
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
          emit(LoginError(errorMessage: context.localeS.invalid_email_address));
        }
      }
    } catch (e) {
      if (isActive) {
        emit(
          LoginError(
            errorMessage: context.localeS.something_went_wrong_please_try_again,
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
    
    // آمن للاستخدام مع SafeTextEditingController
    emailController.clear();
    passwordController.clear();
    
    _isPasswordVisible = false;
    emit(LoginInitial());
  }

  @override
  Future<void> close() {
    _isDisposed = true;
    
    // استخدام فحص isDisposed
    if (!emailController.isDisposed) {
      emailController.dispose();
    }
    
    if (!passwordController.isDisposed) {
      passwordController.dispose();
    }
    
    return super.close();
  }
}