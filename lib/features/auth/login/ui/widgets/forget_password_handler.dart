import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/forget_password_cubit/forget_password_cubit.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

class ForgetPasswordHandler {
  static void handleOtpVerified(BuildContext context, String email, String otpValue) {
    context.showSuccessSnackBar(LocaleKeys.otp_verified_successfully.tr());
    
    final cubit = context.read<ForgetPasswordCubit>();
    cubit.cancelTimer();
    
    final verifiedOtp = cubit.verifiedOtp;
    
    Future.delayed(Duration.zero, () {
      context.pushNamed(
        Routes.resetPasswordView,
        arguments: {
          'email': email, 
          'otp': verifiedOtp ?? otpValue
        },
      );
    });
  }

  static Widget buildBlocConsumer({
    required BuildContext context,
    required double verticalSpacing,
    required double horizontalPadding,
    required bool isDark,
    required String email,
    required TextEditingController otpController,
    required String otpValue,
    required void Function(String) updateOtpValue,
    required Widget Function(
      BuildContext context,
      double verticalSpacing,
      double horizontalPadding,
      bool isDark,
      int timeRemaining,
      bool isLoading,
      Function() onResendOtp,
      Function() onVerifyOtp,
    ) buildScaffold,
  }) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordError) {
          context.showErrorSnackBar(state.message);
        } else if (state is ForgetPasswordOtpVerified) {
          handleOtpVerified(context, email, otpValue);
        } else if (state is ForgetPasswordOtpResent) {
          context.showSuccessSnackBar(LocaleKeys.otp_resent_successfully.tr());
          otpController.clear();
          updateOtpValue('');
        }
      },
      builder: (context, state) {
        final cubit = context.read<ForgetPasswordCubit>();
        final timeRemaining =
            state is ForgetPasswordOtpTimerUpdated
                ? state.timeRemaining
                : cubit.otpTimeRemaining;
        
        return buildScaffold(
          context,
          verticalSpacing,
          horizontalPadding,
          isDark,
          timeRemaining,
          state is ForgetPasswordLoading,
          cubit.resendOtp,
          () => cubit.verifyOtp(otp: otpValue, email: email),
        );
      },
    );
  }
}