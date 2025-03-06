import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/ui/cubits/password_reset/password_reset_cubit.dart';
import 'package:united_formation_app/features/auth/ui/widgets/auth_header.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

class RequestOtpPage extends StatelessWidget {
  const RequestOtpPage({super.key});

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
        } else if (state is PasswordResetOtpSent) {
          context.showSuccessSnackBar(LocaleKeys.otp_sent_successfully.tr());
          
          final email = state.email;
          
          context.pushNamed(
            Routes.verifyOtpView,
            arguments: {'email': email},
          );
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
                      isLoading: state is PasswordResetLoading,
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