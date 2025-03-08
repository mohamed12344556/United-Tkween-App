import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../cubits/password_reset/password_reset_cubit.dart';
import '../widgets/auth_header.dart';

import '../../../../generated/l10n.dart';

class ResetPasswordPage extends StatelessWidget {
  final String email;
  final String otp;

  const ResetPasswordPage({super.key, required this.email, required this.otp});

  @override
  Widget build(BuildContext context) {
    final verticalSpacing = 0.02.sh;
    final horizontalPadding = 0.06.sw;
    final isDark = context.isDarkMode;
    final cubit = context.read<PasswordResetCubit>();

    return BlocListener<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        if (state is PasswordResetError) {
          if (context.mounted) {
            context.showErrorSnackBar(state.message);
          }
        } else if (state is PasswordResetSuccess) {
          if (context.mounted) {
            context.showSuccessSnackBar(
              context.localeS.password_reset_successful,
            );

            Future.microtask(() {
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.loginView,
                  (route) => false,
                  arguments: {'fresh_start': true},
                );
              }
            });
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  AuthHeader(
                    title: context.localeS.reset_password,
                    subtitle:
                        context.localeS.create_a_new_password_for_your_account,
                  ),

                  AppTextField(
                    controller: cubit.passwordController,
                    hintText: context.localeS.new_password,
                    isPassword: true,
                    passwordVisible: cubit.isPasswordVisible,
                    onTogglePasswordVisibility: () {
                      cubit.togglePasswordVisibility();
                    },
                  ),

                  SizedBox(height: verticalSpacing),

                  AppTextField(
                    controller: cubit.confirmPasswordController,
                    hintText: context.localeS.confirm_new_password,
                    isPassword: true,
                    passwordVisible: cubit.isConfirmPasswordVisible,
                    onTogglePasswordVisibility: () {
                      cubit.toggleConfirmPasswordVisibility();
                    },
                  ),

                  SizedBox(height: verticalSpacing * 2),

                  BlocBuilder<PasswordResetCubit, PasswordResetState>(
                    builder: (context, state) {
                      return AppButton(
                        text: S.of(context).reset_password,
                        backgroundColor: AppColors.primary,
                        textColor: Colors.black,
                        isLoading: state is PasswordResetLoading,
                        onPressed: () => _handlePasswordReset(context, cubit),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePasswordReset(BuildContext context, PasswordResetCubit cubit) {
    // تخزين البيانات المطلوبة
    final password = cubit.passwordController.text;
    final confirmPassword = cubit.confirmPasswordController.text;

    // تحقق أساسي من المدخلات
    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.localeS.password_is_required),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.localeS.passwords_do_not_match),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // تنفيذ عملية إعادة التعيين
    cubit.resetPassword(
      email: email,
      otp: otp,
      password: password,
      confirmPassword: confirmPassword,
      context: context,
    );
  }
}
