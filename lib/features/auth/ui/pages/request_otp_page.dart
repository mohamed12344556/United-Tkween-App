import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../../core/utilities/navigation_manager.dart';
import '../cubits/password_reset/password_reset_cubit.dart';
import '../widgets/auth_header.dart';

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
          if (context.mounted) {
            context.showErrorSnackBar(state.message);
          }
        } else if (state is PasswordResetOtpSent) {
          if (context.mounted) {
            context.showSuccessSnackBar(context.localeS.otp_sent_successfully);

            Future.microtask(() {
              if (context.mounted) {
                NavigationManager.navigateToOtpVerification(
                  state.email,
                  isPasswordReset: true,
                );
              }
            });
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: isDark ? Colors.white : AppColors.text,
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
                    AuthHeader(
                      title: context.localeS.forgot_password,
                      subtitle:
                          context
                              .localeS
                              .enter_your_email_address_to_reset_your_password,
                    ),
                    AppTextField(
                      controller: cubit.emailController,
                      hintText: context.localeS.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: verticalSpacing * 2),
                    AppButton(
                      text: context.localeS.get_verification_code,
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.text,
                      isLoading: state is PasswordResetLoading,
                      onPressed: () {
                        cubit.requestOtp(
                          email: cubit.emailController.text.trim(),
                          context: context,
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
}
