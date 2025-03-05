import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/forget_password_cubit/forget_password_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/widgets/auth_header.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

class RequestOtpView extends StatelessWidget {
  const RequestOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final verticalSpacing = context.screenHeight * 0.02;
    final horizontalPadding = context.screenWidth * 0.06;
    final isDark = context.isDarkMode;
    final cubit = context.read<ForgetPasswordCubit>();

    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        print("RequestOtpView state: $state");
        
        if (state is ForgetPasswordError) {
          context.showErrorSnackBar(state.message);
        } else if (state is ForgetPasswordOtpSent) {
          context.showSuccessSnackBar(LocaleKeys.otp_sent_successfully.tr());
          
          // انتقل إلى صفحة التحقق من OTP مع تمرير البريد الإلكتروني بالشكل الصحيح
          final email = state.email;
          print("Navigating to VerifyOtpView with email: $email");
          
          // استخدام Map بدلاً من String للتمييز بين التسجيل واستعادة كلمة المرور
          context.pushNamed(
            Routes.verifyOtpView,
            arguments: {'email': email},
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      title: LocaleKeys.forgot_password.tr(),
                      subtitle: LocaleKeys.enter_your_email_address_to_reset_your_password.tr(),
                    ),

                    // حقل إدخال البريد الإلكتروني
                    AppTextField(
                      controller: cubit.emailController,
                      hintText: LocaleKeys.email.tr(),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // زر طلب OTP
                    AppButton(
                      text: LocaleKeys.get_verification_code.tr(),
                      backgroundColor: AppColors.primary,
                      textColor: Colors.black,
                      isLoading: state is ForgetPasswordLoading,
                      onPressed: () {
                        cubit.requestOtp(email: cubit.emailController.text.trim());
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
}