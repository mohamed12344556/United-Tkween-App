import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map &&
        args.containsKey('fresh_start') &&
        args['fresh_start'] == true) {
      if (mounted) {
        context.read<LoginCubit>().resetState();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = 0.06.sw;
    final verticalSpacing = 0.02.sh;
    final isDark = context.isDarkMode;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          if (mounted) {
            context.showSuccessSnackBar(LocaleKeys.login_successful.tr());
            Future.microtask(() {
              if (mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(Routes.homeView, (route) => false);
              }
            });
          }
        } else if (state is LoginError) {
          if (mounted) {
            context.showErrorSnackBar(state.errorMessage);
          }
        }
      },
      builder: (context, state) {
        final cubit = context.watch<LoginCubit>();
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 1.sh - context.paddingTop - context.paddingBottom,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalSpacing * 2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthHeader(
                        title: LocaleKeys.welcome_back.tr(),
                        subtitle:
                            LocaleKeys
                                .we_happy_to_see_you_here_again_enter_your_email_address_and_password
                                .tr(),
                      ),
                      AppTextField(
                        controller: cubit.emailController,
                        hintText: LocaleKeys.email.tr(),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: verticalSpacing),
                      AppTextField(
                        controller: cubit.passwordController,
                        hintText: LocaleKeys.password.tr(),
                        isPassword: true,
                        passwordVisible: cubit.isPasswordVisible,
                        onTogglePasswordVisibility:
                            cubit.togglePasswordVisibility,
                      ),
                      SizedBox(height: verticalSpacing * 2),
                      AppButton(
                        text: LocaleKeys.log_in.tr(),
                        backgroundColor: AppColors.primary,
                        textColor: Colors.black,
                        isLoading: state is LoginLoading,
                        onPressed: () {
                          if (mounted) {
                            cubit.login(
                              email: cubit.emailController.text.trim(),
                              password: cubit.passwordController.text,
                            );
                          }
                        },
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            if (mounted) {
                              Navigator.of(
                                context,
                              ).pushNamed(Routes.requestOtpView);
                            }
                          },
                          child: Text(
                            LocaleKeys.forgot_password.tr(),
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[300]
                                      : Colors.black54,
                              fontSize: 0.035.sw,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: verticalSpacing * 0.5),
                      CustomDivider(text: LocaleKeys.or.tr()),
                      SizedBox(height: verticalSpacing),
                      AppButton(
                        text: LocaleKeys.create_account.tr(),
                        backgroundColor:
                            isDark ? AppColors.darkSecondary : Colors.black,
                        textColor: Colors.white,
                        onPressed: () {
                          if (mounted) {
                            Navigator.of(
                              context,
                            ).pushNamed(Routes.registerView);
                          }
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
