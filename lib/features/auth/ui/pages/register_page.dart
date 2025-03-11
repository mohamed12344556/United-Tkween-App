import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../cubits/register/register_cubit.dart';
import '../widgets/auth_header.dart';
import '../widgets/social_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterViewContent();
  }
}

class RegisterViewContent extends StatelessWidget {
  const RegisterViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.screenWidth * 0.06;
    final verticalSpacing = context.screenHeight * 0.02;
    final isDark = context.isDarkMode;
    final cubit = context.watch<RegisterCubit>();

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          context.showSuccessSnackBar(
            context.localeS.account_created_successfully,
          );

          Navigator.of(
            context,
          ).pushNamed(Routes.verifyOtpView, arguments: state.userEmail);
        } else if (state is RegisterOtpSent) {
          Navigator.of(
            context,
          ).pushNamed(Routes.verifyOtpView, arguments: state.email);
        } else if (state is RegisterError) {
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalSpacing * 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header (logo, title, subtitle)
                    AuthHeader(
                      title: context.localeS.create_account,
                      subtitle:
                          context.localeS
                              .create_your_account_it_takes_less_than_a_minute_enter_your_email_and_password
                              ,
                    ),

                    // Email field
                    AppTextField(
                      controller: cubit.emailController,
                      hintText: context.localeS.email,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: verticalSpacing),

                    // Password field
                    AppTextField(
                      controller: cubit.passwordController,
                      hintText: context.localeS.password,
                      isPassword: true,
                      passwordVisible: cubit.isPasswordVisible,
                      onTogglePasswordVisibility: () {
                        cubit.togglePasswordVisibility();
                      },
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Register button
                    AppButton(
                      text: context.localeS.create_an_account,
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.text,
                      isLoading: state is RegisterLoading,
                      onPressed: () {
                        cubit.registerWithEmailAndPassword(context);
                      },
                    ),

                    SizedBox(height: verticalSpacing),

                    // Divider with OR
                    CustomDivider(text: context.localeS.or),

                    SizedBox(height: verticalSpacing),

                    // Google sign in
                    SocialButton(
                      onPressed: () {
                        cubit.registerWithSocialMedia('google',context);
                      },
                      icon: Assets.google,
                      text: context.localeS.continue_with_google,
                    ),

                    SizedBox(height: verticalSpacing * 0.8),

                    // Facebook sign in
                    SocialButton(
                      onPressed: () {
                        cubit.registerWithSocialMedia('facebook',context);
                      },
                      icon: Assets.facebook,
                      text: context.localeS.continue_with_facebook,
                    ),

                    SizedBox(height: verticalSpacing * 0.8),

                    // Apple sign in
                    SocialButton(
                      onPressed: () {
                        cubit.registerWithSocialMedia('apple',context);
                      },
                      icon: Assets.apple,
                      text: context.localeS.continue_with_apple,
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    // Login option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.localeS.already_have_an_account,
                          style: TextStyle(
                            color: isDark ? AppColors.textHint : AppColors.text,
                            fontSize: context.screenWidth * 0.035,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.pushNamed(Routes.loginView);
                          },
                          child: Text(
                            context.localeS.log_in,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: context.screenWidth * 0.035,
                            ),
                          ),
                        ),
                      ],
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
}
