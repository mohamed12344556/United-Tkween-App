import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';
import '../cubits/register/register_cubit.dart';
import '../widgets/auth_header.dart';

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
    final cubit = context.watch<RegisterCubit>();

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          context.showSuccessSnackBar(
            context.localeS.account_created_successfully,
          );

          Navigator.of(
            context,
          ).pushNamed(Routes.learningOptionsView, arguments: state.userEmail);
        } else if (state is RegisterError) {
          context.showErrorSnackBar(state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalSpacing * 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthHeader(
                      title: context.localeS.welcome_back,
                      subtitle:
                          context
                              .localeS
                              .create_your_account_it_takes_less_than_a_minute_enter_your_email_and_password,
                    ),

                    // حقل الاسم الكامل
                    AppTextField(
                      controller: cubit.nameController,
                      hintText: context.localeS.full_name,
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: verticalSpacing),

                    // حقل البريد الإلكتروني
                    AppTextField(
                      controller: cubit.emailController,
                      hintText: context.localeS.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: verticalSpacing),

                    // حقل رقم الهاتف
                    // if (!Platform.isIOS) ...[
                    //   AppTextField(
                    //     controller: cubit.phoneController,
                    //     hintText: context.localeS.phone,
                    //     keyboardType: TextInputType.phone,
                    //   ),
                    //   SizedBox(height: verticalSpacing),
                    // ],
                    AppTextField(
                      controller: cubit.phoneController,
                      hintText: context.localeS.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: verticalSpacing),

                    // حقل كلمة المرور
                    AppTextField(
                      controller: cubit.passwordController,
                      hintText: context.localeS.password,
                      isPassword: true,
                      passwordVisible: cubit.isPasswordVisible,
                      onTogglePasswordVisibility:
                          cubit.togglePasswordVisibility,
                    ),
                    SizedBox(height: verticalSpacing),

                    // حقل العنوان
                    // if (!Platform.isIOS) ...[
                    //   AppTextField(
                    //     controller: cubit.addressController,
                    //     hintText: context.localeS.address,
                    //     keyboardType: TextInputType.streetAddress,
                    //   ),

                    //   SizedBox(height: verticalSpacing * 2),
                    // ],
                    AppTextField(
                      controller: cubit.addressController,
                      hintText: context.localeS.address,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    SizedBox(height: verticalSpacing * 2),

                    AppButton(
                      text: context.localeS.create_an_account,
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                      isLoading: state is RegisterLoading,
                      onPressed: () {
                        cubit.register(context);
                      },
                    ),
                    SizedBox(height: verticalSpacing * 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.localeS.already_have_an_account,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: context.screenWidth * 0.035,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.pop();
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
