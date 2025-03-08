import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../cubits/login/login_cubit.dart';
import '../widgets/auth_header.dart';

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
            context.showSuccessSnackBar(context.localeS.login_successful);
            Future.microtask(() {
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.settingsView,
                  (route) => false,
                );
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
                        title: context.localeS.welcome_back,
                        subtitle:
                            context
                                .localeS
                                .we_happy_to_see_you_here_again_enter_your_email_address_and_password,
                      ),
                      AppTextField(
                        controller: cubit.emailController,
                        hintText: context.localeS.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: verticalSpacing),
                      AppTextField(
                        controller: cubit.passwordController,
                        hintText: context.localeS.password,
                        isPassword: true,
                        passwordVisible: cubit.isPasswordVisible,
                        onTogglePasswordVisibility:
                            cubit.togglePasswordVisibility,
                      ),
                      SizedBox(height: verticalSpacing * 2),
                      AppButton(
                        text: context.localeS.log_in,
                        backgroundColor: AppColors.primary,
                        textColor: Colors.black,
                        isLoading: state is LoginLoading,
                        onPressed: () {
                          if (mounted) {
                            cubit.login(
                              email: cubit.emailController.text.trim(),
                              password: cubit.passwordController.text,
                              context: context,
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
                            context.localeS.forgot_password,
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
                      CustomDivider(text: context.localeS.or),
                      SizedBox(height: verticalSpacing),
                      AppButton(
                        text: context.localeS.create_account,
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
