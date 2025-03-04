import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/auth/login/ui/widgets/auth_header.dart';
import 'package:united_formation_app/features/auth/signup/ui/logic/register_cubit.dart';
import 'package:united_formation_app/features/auth/signup/ui/widgets/social_button.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';
import '../../../../../core/core.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

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
            LocaleKeys.account_created_successfully.tr(),
          );
          context.pushNamedAndRemoveUntil(
            Routes.learningOptionsView,
            predicate: (route) => false,
          );
        } else if (state is RegisterError) {
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      title: LocaleKeys.create_account.tr(),
                      subtitle:
                          LocaleKeys
                              .create_your_account_it_takes_less_than_a_minute_enter_your_email_and_password
                              .tr(),
                    ),

                    // Email field
                    AppTextField(
                      controller: cubit.emailController,
                      hintText: LocaleKeys.email.tr(),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: verticalSpacing),

                    // Password field
                    AppTextField(
                      controller: cubit.passwordController,
                      hintText: LocaleKeys.password.tr(),
                      isPassword: true,
                      passwordVisible: cubit.isPasswordVisible,
                      onTogglePasswordVisibility: () {
                        cubit.togglePasswordVisibility();
                      },
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Register button
                    AppButton(
                      text: LocaleKeys.create_an_account.tr(),
                      backgroundColor: AppColors.primary,
                      textColor: Colors.black,
                      isLoading: state is RegisterLoading,
                      onPressed: () {
                        cubit.registerWithEmailAndPassword();
                      },
                    ),

                    SizedBox(height: verticalSpacing),

                    // Divider with OR
                    CustomDivider(text: LocaleKeys.or.tr()),

                    SizedBox(height: verticalSpacing),

                    // Google sign in
                    SocialButton(
                      onPressed: () {
                        cubit.registerWithSocialMedia('google');
                      },
                      icon: Assets.google,
                      text: LocaleKeys.continue_with_google.tr(),
                    ),

                    SizedBox(height: verticalSpacing * 0.8),

                    // Facebook sign in
                    SocialButton(
                      onPressed: () {
                        cubit.registerWithSocialMedia('facebook');
                      },
                      icon: Assets.facebook,
                      text: LocaleKeys.continue_with_facebook.tr(),
                    ),

                    SizedBox(height: verticalSpacing * 0.8),

                    // Apple sign in
                    SocialButton(
                      onPressed: () {
                        cubit.registerWithSocialMedia('apple');
                      },
                      icon: Assets.apple,
                      text: LocaleKeys.continue_with_apple.tr(),
                    ),

                    SizedBox(height: verticalSpacing * 1.5),

                    // Login option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.already_have_an_account.tr(),
                          style: TextStyle(
                            color: isDark ? Colors.grey[300] : Colors.black54,
                            fontSize: context.screenWidth * 0.035,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.pushNamed(Routes.loginView);
                          },
                          child: Text(
                            LocaleKeys.log_in.tr(),
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
