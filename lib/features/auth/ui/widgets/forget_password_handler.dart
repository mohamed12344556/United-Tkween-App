import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../cubits/password_reset/password_reset_cubit.dart';

class PasswordResetHandler {
  static void handleOtpVerified(
    BuildContext context,
    String email,
    String otpValue,
  ) {
    final cubit = context.read<PasswordResetCubit>();
    final verifiedOtp = cubit.verifiedOtp ?? otpValue;

    cubit.cancelTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.localeS.otp_verified_successfully),
            backgroundColor: AppColors.success, // Use AppColors.success
          ),
        );

        Navigator.of(context).pushReplacementNamed(
          Routes.resetPasswordView,
          arguments: {'email': email, 'otp': verifiedOtp},
        );
      }
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
    )
    buildScaffold,
  }) {
    return BlocConsumer<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        if (state is PasswordResetError) {
          if (context.mounted) {
            context.showErrorSnackBar(state.message);
          }
        } else if (state is PasswordResetOtpVerified) {
          handleOtpVerified(context, email, otpValue);
        } else if (state is PasswordResetOtpResent) {
          if (context.mounted) {
            context.showSuccessSnackBar(
              context.localeS.otp_resent_successfully,
            );
            otpController.clear();
            updateOtpValue('');
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<PasswordResetCubit>();
        final timeRemaining =
            state is PasswordResetOtpTimerUpdated
                ? state.timeRemaining
                : cubit.otpTimeRemaining;

        return buildScaffold(
          context,
          verticalSpacing,
          horizontalPadding,
          isDark,
          timeRemaining,
          state is PasswordResetLoading,
          () => cubit.resendOtp(context),
          () => cubit.verifyOtp(otp: otpValue, email: email, context: context),
        );
      },
    );
  }
}
