// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:united_formation_app/core/core.dart';
// import 'package:united_formation_app/features/auth/ui/cubits/otp/otp_cubit.dart';
// import 'package:united_formation_app/generated/locale_keys.g.dart';

// class SignupOtpHandler {
//   static void handleOtpVerified(BuildContext context) {
//     context.showSuccessSnackBar(LocaleKeys.otp_verified_successfully.tr());
    
//     final cubit = context.read<OtpCubit>();
//     cubit.cancelTimer();
    
//     Future.delayed(Duration.zero, () {
//       Navigator.of(context).pushNamedAndRemoveUntil(
//         Routes.learningOptionsView, 
//         (route) => false
//       );
//     });
//   }

//   static Widget buildBlocConsumer({
//     required BuildContext context,
//     required double verticalSpacing,
//     required double horizontalPadding,
//     required bool isDark,
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
//     return BlocConsumer<OtpCubit, OtpState>(
//       listener: (context, state) {
//         if (state is OtpError) {
//           context.showErrorSnackBar(state.message);
//         } else if (state is OtpVerified) {
//           handleOtpVerified(context);
//         } else if (state is OtpResent) {
//           context.showSuccessSnackBar(LocaleKeys.otp_resent_successfully.tr());
//           otpController.clear();
//           updateOtpValue('');
//         }
//       },
//       builder: (context, state) {
//         final cubit = context.read<OtpCubit>();
//         final timeRemaining =
//             state is OtpTimerUpdated
//                 ? state.timeRemaining
//                 : cubit.otpTimeRemaining;
        
//         return buildScaffold(
//           context,
//           verticalSpacing,
//           horizontalPadding,
//           isDark,
//           timeRemaining,
//           state is OtpLoading,
//           () => cubit.resendOtp(),
//           () => cubit.verifyOtp(otp: otpValue),
//         );
//       },
//     );
//   }
// }



// تعديل ملف signup_otp_handler.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/ui/cubits/otp/otp_cubit.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

class SignupOtpHandler {
  static void handleOtpVerified(BuildContext context) {
    // تخزين القيم المهمة قبل عرض الرسالة
    final cubit = context.read<OtpCubit>();
    
    // إلغاء المؤقت
    cubit.cancelTimer();
    
    // تأخير لعدم استخدام السياق بعد إزالة الـwidget
    Future.microtask(() {
      if (context.mounted) {
        context.showSuccessSnackBar(LocaleKeys.otp_verified_successfully.tr());
        
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.learningOptionsView, 
          (route) => false
        );
      }
    });
  }

  static Widget buildBlocConsumer({
    required BuildContext context,
    required double verticalSpacing,
    required double horizontalPadding,
    required bool isDark,
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
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is OtpError) {
          if (context.mounted) {
            context.showErrorSnackBar(state.message);
          }
        } else if (state is OtpVerified) {
          handleOtpVerified(context);
        } else if (state is OtpResent) {
          if (context.mounted) {
            context.showSuccessSnackBar(LocaleKeys.otp_resent_successfully.tr());
            otpController.clear();
            updateOtpValue('');
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<OtpCubit>();
        final timeRemaining =
            state is OtpTimerUpdated
                ? state.timeRemaining
                : cubit.otpTimeRemaining;
        
        return buildScaffold(
          context,
          verticalSpacing,
          horizontalPadding,
          isDark,
          timeRemaining,
          state is OtpLoading,
          () => cubit.resendOtp(),
          () => cubit.verifyOtp(otp: otpValue),
        );
      },
    );
  }
}