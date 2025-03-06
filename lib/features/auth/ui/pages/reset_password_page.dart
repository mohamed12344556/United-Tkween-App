import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/ui/cubits/password_reset/password_reset_cubit.dart';
import 'package:united_formation_app/features/auth/ui/widgets/auth_header.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

class ResetPasswordPage extends StatelessWidget {
  final String email;
  final String otp;

  const ResetPasswordPage({super.key, required this.email, required this.otp});

  @override
  Widget build(BuildContext context) {
    final verticalSpacing = context.screenHeight * 0.02;
    final horizontalPadding = context.screenWidth * 0.06;
    final isDark = context.isDarkMode;
    final cubit = context.read<PasswordResetCubit>();

    return BlocConsumer<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        if (state is PasswordResetError) {
          context.showErrorSnackBar(state.message);
        } else if (state is PasswordResetSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              // تحديد cubit جديد عند الانتقال
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.loginView,
                (route) => false,
                arguments: {
                  'fresh_start': true,
                }, // إضافة معلمة للإشارة إلى بدء جديد
              );
            }
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : Colors.black,
            ),
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
                      title: LocaleKeys.reset_password.tr(),
                      subtitle:
                          LocaleKeys.create_a_new_password_for_your_account
                              .tr(),
                    ),

                    // حقل كلمة المرور
                    AppTextField(
                      controller: cubit.passwordController,
                      hintText: LocaleKeys.new_password.tr(),
                      isPassword: true,
                      passwordVisible: cubit.isPasswordVisible,
                      onTogglePasswordVisibility: () {
                        cubit.togglePasswordVisibility();
                      },
                    ),

                    SizedBox(height: verticalSpacing),

                    // حقل تأكيد كلمة المرور
                    AppTextField(
                      controller: cubit.confirmPasswordController,
                      hintText: LocaleKeys.confirm_new_password.tr(),
                      isPassword: true,
                      passwordVisible: cubit.isConfirmPasswordVisible,
                      onTogglePasswordVisibility: () {
                        cubit.toggleConfirmPasswordVisibility();
                      },
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // زر إعادة تعيين كلمة المرور
                    AppButton(
                      text: LocaleKeys.reset_password.tr(),
                      backgroundColor: AppColors.primary,
                      textColor: Colors.black,
                      isLoading: state is PasswordResetLoading,
                      onPressed: () {
                        cubit.resetPassword(
                          email: email,
                          otp: otp,
                          password: cubit.passwordController.text,
                          confirmPassword: cubit.confirmPasswordController.text,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handlePasswordReset(
    BuildContext context,
    PasswordResetCubit cubit,
    String email,
    String otp,
  ) {
    // تخزين البيانات المطلوبة
    final password = cubit.passwordController.text;
    final confirmPassword = cubit.confirmPasswordController.text;

    // تحقق أساسي من المدخلات
    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.password_is_required.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.passwords_do_not_match.tr()),
          backgroundColor: Colors.red,
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
    );
  }
}
