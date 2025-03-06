// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:united_formation_app/core/core.dart';
// import 'package:united_formation_app/features/auth/ui/cubits/password_reset/password_reset_cubit.dart';
// import 'package:united_formation_app/generated/locale_keys.g.dart';

// class PasswordResetHandler {
//   static void handleOtpVerified(BuildContext context, String email, String otpValue) {
//     context.showSuccessSnackBar(LocaleKeys.otp_verified_successfully.tr());
    
//     final cubit = context.read<PasswordResetCubit>();
//     cubit.cancelTimer();
    
//     final verifiedOtp = cubit.verifiedOtp;
    
//     Future.delayed(Duration.zero, () {
//       context.pushNamed(
//         Routes.resetPasswordView,
//         arguments: {
//           'email': email, 
//           'otp': verifiedOtp ?? otpValue
//         },
//       );
//     });
//   }

//   static Widget buildBlocConsumer({
//     required BuildContext context,
//     required double verticalSpacing,
//     required double horizontalPadding,
//     required bool isDark,
//     required String email,
//     required TextEditingController otpController,
//     required String otpValue,
//     required void Function(String) updateOtpValue,
//     required Widget Function(
//       BuildContext context,
//       double verticalSpacing,
//       double horizontalPadding,
//       bool isDark,
//       int timeRemaining,
//       bool isLoading,
//       Function() onResendOtp,
//       Function() onVerifyOtp,
//     ) buildScaffold,
//   }) {
//     return BlocConsumer<PasswordResetCubit, PasswordResetState>(
//       listener: (context, state) {
//         if (state is PasswordResetError) {
//           context.showErrorSnackBar(state.message);
//         } else if (state is PasswordResetOtpVerified) {
//           handleOtpVerified(context, email, otpValue);
//         } else if (state is PasswordResetOtpResent) {
//           context.showSuccessSnackBar(LocaleKeys.otp_resent_successfully.tr());
//           otpController.clear();
//           updateOtpValue('');
//         }
//       },
//       builder: (context, state) {
//         final cubit = context.read<PasswordResetCubit>();
//         final timeRemaining =
//             state is PasswordResetOtpTimerUpdated
//                 ? state.timeRemaining
//                 : cubit.otpTimeRemaining;
        
//         return buildScaffold(
//           context,
//           verticalSpacing,
//           horizontalPadding,
//           isDark,
//           timeRemaining,
//           state is PasswordResetLoading,
//           cubit.resendOtp,
//           () => cubit.verifyOtp(otp: otpValue, email: email),
//         );
//       },
//     );
//   }
// }


// تعديل ملف forget_password_handler.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/ui/cubits/password_reset/password_reset_cubit.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

class PasswordResetHandler {
  static void handleOtpVerified(BuildContext context, String email, String otpValue) {
    // تخزين القيم المهمة قبل عرض الرسالة
    final cubit = context.read<PasswordResetCubit>();
    final verifiedOtp = cubit.verifiedOtp ?? otpValue;
    
    // إلغاء المؤقت
    cubit.cancelTimer();
    
    // تجنب استخدام السياق مباشرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        // عرض رسالة النجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.otp_verified_successfully.tr()),
            backgroundColor: Colors.green,
          ),
        );
        
        // الانتقال إلى صفحة إعادة تعيين كلمة المرور
        // استخدام pushReplacementNamed بدلاً من pushNamed لتجنب تراكم الصفحات
        Navigator.of(context).pushReplacementNamed(
          Routes.resetPasswordView,
          arguments: {
            'email': email, 
            'otp': verifiedOtp
          },
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
    ) buildScaffold,
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
            context.showSuccessSnackBar(LocaleKeys.otp_resent_successfully.tr());
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
          cubit.resendOtp,
          () => cubit.verifyOtp(otp: otpValue, email: email),
        );
      },
    );
  }
}