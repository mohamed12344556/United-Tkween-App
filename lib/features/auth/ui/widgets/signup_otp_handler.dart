// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/core.dart';
// import '../cubits/otp/otp_cubit.dart';

// class SignupOtpHandler {
//   static void handleOtpVerified(BuildContext context) {
//     final cubit = context.read<OtpCubit>();

//     cubit.cancelTimer();

//     Future.microtask(() {
//       if (context.mounted) {
//         context.showSuccessSnackBar(context.localeS.otp_verified_successfully);

//         Navigator.of(
//           context,
//         ).pushNamedAndRemoveUntil(Routes.learningOptionsView, (route) => false);
//       }
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
//     )
//     buildScaffold,
//   }) {
//     return BlocConsumer<OtpCubit, OtpState>(
//       listener: (context, state) {
//         if (state is OtpError) {
//           if (context.mounted) {
//             context.showErrorSnackBar(state.message);
//           }
//         } else if (state is OtpVerified) {
//           handleOtpVerified(context);
//         } else if (state is OtpResent) {
//           if (context.mounted) {
//             context.showSuccessSnackBar(
//               context.localeS.otp_resent_successfully,
//             );
//             otpController.clear();
//             updateOtpValue('');
//           }
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
//           () => cubit.verifyOtp(otp: otpValue, context: context),
//         );
//       },
//     );
//   }
// }
