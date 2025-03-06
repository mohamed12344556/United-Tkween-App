import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/ui/cubits/login/login_cubit.dart';
import 'package:united_formation_app/features/auth/ui/widgets/auth_header.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.screenWidth * 0.06;
    final verticalSpacing = context.screenHeight * 0.02;
    final cubit = context.watch<LoginCubit>();

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Show success message and navigate to home
          context.showSuccessSnackBar(LocaleKeys.login_successful.tr());
          context.pushNamedAndRemoveUntil(
            Routes.homeView,
            predicate: (route) => false,
          );
        } else if (state is LoginError) {
          // Show error message
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      context.screenHeight -
                      context.paddingTop -
                      context.paddingBottom,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalSpacing * 2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (logo, title, subtitle)
                      AuthHeader(
                        title: LocaleKeys.welcome_back.tr(),
                        subtitle:
                            LocaleKeys
                                .we_happy_to_see_you_here_again_enter_your_email_address_and_password
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
                          if (mounted) {
                            setState(() {
                              cubit.isPasswordVisible =
                                  !cubit.isPasswordVisible;
                            });
                          }
                        },
                      ),

                      SizedBox(height: verticalSpacing * 2),

                      // Login button
                      AppButton(
                        text: LocaleKeys.log_in.tr(),
                        backgroundColor: AppColors.primary,
                        textColor: Colors.black,
                        isLoading: state is LoginLoading,
                        onPressed: () {
                          context.read<LoginCubit>().login(
                            email: cubit.emailController.text.trim(),
                            password: cubit.passwordController.text,
                          );
                        },
                      ),

                      // Forgot password
                      Center(
                        child: TextButton(
                          onPressed: () {
                            context.pushNamed(Routes.requestOtpView);
                          },
                          child: Text(
                            LocaleKeys.forgot_password.tr(),
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[300]
                                      : Colors.black54,
                              fontSize: context.screenWidth * 0.035,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: verticalSpacing * 0.5),

                      // Divider with OR
                      CustomDivider(text: LocaleKeys.or.tr()),

                      SizedBox(height: verticalSpacing),

                      // Register button
                      AppButton(
                        text: LocaleKeys.create_account.tr(),
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkSecondary
                                : Colors.black,
                        textColor: Colors.white,
                        onPressed: () {
                          context.pushNamed(Routes.registerView);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
