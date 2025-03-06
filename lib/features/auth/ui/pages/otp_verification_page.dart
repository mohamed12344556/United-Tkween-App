// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:united_formation_app/features/auth/ui/cubits/otp/otp_cubit.dart';
// import 'package:united_formation_app/features/auth/ui/cubits/password_reset/password_reset_cubit.dart';
// import 'package:united_formation_app/features/auth/ui/widgets/auth_header.dart';
// import 'package:united_formation_app/features/auth/ui/widgets/otp_input_field.dart';
// import 'package:united_formation_app/features/auth/ui/widgets/resend_otp_row.dart';
// import 'package:united_formation_app/generated/locale_keys.g.dart';

// import '../../../../core/core.dart';

// class OtpVerificationPage extends StatefulWidget {
//   final String email;

//   const OtpVerificationPage({super.key, required this.email});

//   @override
//   State<OtpVerificationPage> createState() => _OtpVerificationPageState();
// }

// class _OtpVerificationPageState extends State<OtpVerificationPage> {
//   final TextEditingController _otpController = TextEditingController();
//   String _otpValue = '';
//   bool _isMounted = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) _initOtpProcess();
//     });
//   }

//   void _initOtpProcess() {
//     if (context.read<PasswordResetCubit?>() != null) {
//       context.read<PasswordResetCubit>().requestOtp(email: widget.email);
//     } else if (context.read<OtpCubit?>() != null) {
//       final otpCubit = context.read<OtpCubit>();
//       if (otpCubit.otpTimeRemaining <= 0) otpCubit.resendOtp();
//     }
//   }

//   @override
//   void setState(VoidCallback fn) {
//     if (_isMounted) super.setState(fn);
//   }

//   @override
//   void dispose() {
//     _isMounted = false;
//     _disposeCubits();
//     _otpController.dispose();
//     super.dispose();
//   }

//   void _disposeCubits() {
//     try {
//       context.read<OtpCubit?>()?.cancelTimer();
//       context.read<PasswordResetCubit?>()?.cancelTimer();
//     } catch (e) {
//       print('Error disposing cubits: $e');
//     }
//   }

//   void _updateOtpValue(String value) {
//     if (_isMounted) setState(() => _otpValue = value);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final verticalSpacing = context.screenHeight * 0.02;
//     final horizontalPadding = context.screenWidth * 0.06;
//     final isDark = context.isDarkMode;
//     final isAccountVerification = context.read<PasswordResetCubit?>() == null;

//     return isAccountVerification
//         ? _buildWithOtpCubit(
//           verticalSpacing: verticalSpacing,
//           horizontalPadding: horizontalPadding,
//           isDark: isDark,
//         )
//         : _buildWithPasswordResetCubit(
//           verticalSpacing: verticalSpacing,
//           horizontalPadding: horizontalPadding,
//           isDark: isDark,
//           email: widget.email,
//         );
//   }

//   Widget _buildWithOtpCubit({
//     required double verticalSpacing,
//     required double horizontalPadding,
//     required bool isDark,
//   }) {
//     return BlocConsumer<OtpCubit, OtpState>(
//       listener: (context, state) {
//         if (state is OtpError) {
//           context.showErrorSnackBar(state.message);
//         } else if (state is OtpVerified) {
//           context.showSuccessSnackBar(
//             LocaleKeys.otp_verified_successfully.tr(),
//           );

//           final cubit = context.read<OtpCubit>();
//           cubit.cancelTimer();

//           if (state.purpose == OtpPurpose.accountVerification) {
//             Navigator.of(context).pushNamedAndRemoveUntil(
//               Routes.learningOptionsView,
//               (route) => false,
//             );
//           }
//         } else if (state is OtpResent) {
//           context.showSuccessSnackBar(LocaleKeys.otp_resent_successfully.tr());
//           _otpController.clear();
//           _updateOtpValue('');
//         }
//       },
//       builder: (context, state) {
//         final cubit = context.read<OtpCubit>();
//         final timeRemaining =
//             state is OtpTimerUpdated
//                 ? state.timeRemaining
//                 : cubit.otpTimeRemaining;

//         return _buildScaffold(
//           timeRemaining: timeRemaining,
//           isLoading: state is OtpLoading,
//           onResendOtp: () => cubit.resendOtp(),
//           onVerifyOtp: () => cubit.verifyOtp(otp: _otpValue),
//           verticalSpacing: verticalSpacing,
//           horizontalPadding: horizontalPadding,
//           isDark: isDark,
//         );
//       },
//     );
//   }

//   Widget _buildWithPasswordResetCubit({
//     required double verticalSpacing,
//     required double horizontalPadding,
//     required bool isDark,
//     required String email,
//   }) {
//     return BlocConsumer<PasswordResetCubit, PasswordResetState>(
//       listener: (context, state) {
//         if (state is PasswordResetError) {
//           context.showErrorSnackBar(state.message);
//         } else if (state is PasswordResetOtpVerified) {
//           context.showSuccessSnackBar(
//             LocaleKeys.otp_verified_successfully.tr(),
//           );

//           final cubit = context.read<PasswordResetCubit>();
//           cubit.cancelTimer();

//           final verifiedOtp = cubit.verifiedOtp ?? _otpValue;

//           Navigator.of(context).pushNamed(
//             Routes.resetPasswordView,
//             arguments: {'email': email, 'otp': verifiedOtp},
//           );
//         } else if (state is PasswordResetOtpResent) {
//           context.showSuccessSnackBar(LocaleKeys.otp_resent_successfully.tr());
//           _otpController.clear();
//           _updateOtpValue('');
//         }
//       },
//       builder: (context, state) {
//         final cubit = context.read<PasswordResetCubit>();
//         final timeRemaining =
//             state is PasswordResetOtpTimerUpdated
//                 ? state.timeRemaining
//                 : cubit.otpTimeRemaining;

//         return _buildScaffold(
//           timeRemaining: timeRemaining,
//           isLoading: state is PasswordResetLoading,
//           onResendOtp: () => cubit.resendOtp(),
//           onVerifyOtp: () => cubit.verifyOtp(otp: _otpValue, email: email),
//           verticalSpacing: verticalSpacing,
//           horizontalPadding: horizontalPadding,
//           isDark: isDark,
//         );
//       },
//     );
//   }

//   Widget _buildScaffold({
//     required int timeRemaining,
//     required bool isLoading,
//     required VoidCallback onResendOtp,
//     required VoidCallback onVerifyOtp,
//     required double verticalSpacing,
//     required double horizontalPadding,
//     required bool isDark,
//   }) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             if (_isMounted) Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: horizontalPadding,
//               vertical: verticalSpacing,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AuthHeader(
//                   title: LocaleKeys.verify_your_email.tr(),
//                   subtitle:
//                       LocaleKeys
//                           .please_enter_the_4_digit_code_sent_to_your_email_address
//                           .tr(),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(bottom: verticalSpacing),
//                   child: Text(
//                     widget.email,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: context.screenWidth * 0.04,
//                       color: isDark ? Colors.white : Colors.black,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: verticalSpacing),
//                 OtpInputField(
//                   context: context,
//                   isDark: isDark,
//                   controller: _otpController,
//                   onChanged: _updateOtpValue,
//                   onCompleted: (value) => setState(() => _otpValue = value),
//                 ),
//                 SizedBox(height: verticalSpacing * 2),
//                 ResendOtpRow(
//                   timeRemaining: timeRemaining,
//                   isDark: isDark,
//                   onResendOtp: onResendOtp,
//                 ),
//                 SizedBox(height: verticalSpacing * 2),
//                 AppButton(
//                   text: LocaleKeys.verify.tr(),
//                   backgroundColor: AppColors.primary,
//                   textColor: Colors.black,
//                   isLoading: isLoading,
//                   onPressed: onVerifyOtp,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// تعديل ملف otp_verification_page.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/auth/ui/cubits/otp/otp_cubit.dart';
import 'package:united_formation_app/features/auth/ui/cubits/password_reset/password_reset_cubit.dart';
import 'package:united_formation_app/features/auth/ui/widgets/auth_header.dart';
import 'package:united_formation_app/features/auth/ui/widgets/otp_input_field.dart';
import 'package:united_formation_app/features/auth/ui/widgets/resend_otp_row.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

import '../../../../core/core.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  String _otpValue = '';
  // حذف متغير _isMounted لأنه قد يؤدي لمشاكل
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initOtpProcess();
    });
  }

  void _initOtpProcess() {
    if (context.read<PasswordResetCubit?>() != null) {
      context.read<PasswordResetCubit>().requestOtp(email: widget.email);
    } else if (context.read<OtpCubit?>() != null) {
      final otpCubit = context.read<OtpCubit>();
      if (otpCubit.otpTimeRemaining <= 0) otpCubit.resendOtp();
    }
  }

  // استخدام mounted بشكل صحيح للتحقق إذا كان الـ widget لا يزال في شجرة الـ widget
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    // التخلص من المؤقتات قبل التخلص من وحدات التحكم
    _disposeCubits();
    _otpController.dispose();
    super.dispose();
  }

  void _disposeCubits() {
    try {
      if (mounted) {
        final otpCubit = context.read<OtpCubit?>();
        if (otpCubit != null) otpCubit.cancelTimer();
        
        final passwordResetCubit = context.read<PasswordResetCubit?>();
        if (passwordResetCubit != null) passwordResetCubit.cancelTimer();
      }
    } catch (e) {
      print('Error disposing cubits: $e');
    }
  }

  void _updateOtpValue(String value) {
    if (mounted) setState(() => _otpValue = value);
  }

  @override
  Widget build(BuildContext context) {
    final verticalSpacing = context.screenHeight * 0.02;
    final horizontalPadding = context.screenWidth * 0.06;
    final isDark = context.isDarkMode;
    final isAccountVerification = context.read<PasswordResetCubit?>() == null;

    return isAccountVerification
        ? _buildWithOtpCubit(
          verticalSpacing: verticalSpacing,
          horizontalPadding: horizontalPadding,
          isDark: isDark,
        )
        : _buildWithPasswordResetCubit(
          verticalSpacing: verticalSpacing,
          horizontalPadding: horizontalPadding,
          isDark: isDark,
          email: widget.email,
        );
  }

  Widget _buildWithOtpCubit({
    required double verticalSpacing,
    required double horizontalPadding,
    required bool isDark,
  }) {
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is OtpError) {
          context.showErrorSnackBar(state.message);
        } else if (state is OtpVerified) {
          context.showSuccessSnackBar(
            LocaleKeys.otp_verified_successfully.tr(),
          );

          if (mounted) {
            final cubit = context.read<OtpCubit>();
            cubit.cancelTimer();

            if (state.purpose == OtpPurpose.accountVerification) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.learningOptionsView,
                (route) => false,
              );
            }
          }
        } else if (state is OtpResent) {
          context.showSuccessSnackBar(LocaleKeys.otp_resent_successfully.tr());
          _otpController.clear();
          _updateOtpValue('');
        }
      },
      builder: (context, state) {
        final cubit = context.read<OtpCubit>();
        final timeRemaining =
            state is OtpTimerUpdated
                ? state.timeRemaining
                : cubit.otpTimeRemaining;

        return _buildScaffold(
          timeRemaining: timeRemaining,
          isLoading: state is OtpLoading,
          onResendOtp: () => cubit.resendOtp(),
          onVerifyOtp: () => cubit.verifyOtp(otp: _otpValue),
          verticalSpacing: verticalSpacing,
          horizontalPadding: horizontalPadding,
          isDark: isDark,
        );
      },
    );
  }

  Widget _buildWithPasswordResetCubit({
    required double verticalSpacing,
    required double horizontalPadding,
    required bool isDark,
    required String email,
  }) {
    return BlocConsumer<PasswordResetCubit, PasswordResetState>(
      listener: (context, state) {
        if (state is PasswordResetError) {
          context.showErrorSnackBar(state.message);
        } else if (state is PasswordResetOtpVerified) {
          context.showSuccessSnackBar(
            LocaleKeys.otp_verified_successfully.tr(),
          );

          if (mounted) {
            final cubit = context.read<PasswordResetCubit>();
            cubit.cancelTimer();

            final verifiedOtp = cubit.verifiedOtp ?? _otpValue;

            Navigator.of(context).pushNamed(
              Routes.resetPasswordView,
              arguments: {'email': email, 'otp': verifiedOtp},
            );
          }
        } else if (state is PasswordResetOtpResent) {
          context.showSuccessSnackBar(LocaleKeys.otp_resent_successfully.tr());
          _otpController.clear();
          _updateOtpValue('');
        }
      },
      builder: (context, state) {
        final cubit = context.read<PasswordResetCubit>();
        final timeRemaining =
            state is PasswordResetOtpTimerUpdated
                ? state.timeRemaining
                : cubit.otpTimeRemaining;

        return _buildScaffold(
          timeRemaining: timeRemaining,
          isLoading: state is PasswordResetLoading,
          onResendOtp: () => cubit.resendOtp(),
          onVerifyOtp: () => cubit.verifyOtp(otp: _otpValue, email: email),
          verticalSpacing: verticalSpacing,
          horizontalPadding: horizontalPadding,
          isDark: isDark,
        );
      },
    );
  }

  Widget _buildScaffold({
    required int timeRemaining,
    required bool isLoading,
    required VoidCallback onResendOtp,
    required VoidCallback onVerifyOtp,
    required double verticalSpacing,
    required double horizontalPadding,
    required bool isDark,
  }) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (mounted) Navigator.of(context).pop();
          },
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
                  title: LocaleKeys.verify_your_email.tr(),
                  subtitle:
                      LocaleKeys
                          .please_enter_the_4_digit_code_sent_to_your_email_address
                          .tr(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: verticalSpacing),
                  child: Text(
                    widget.email,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: context.screenWidth * 0.04,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: verticalSpacing),
                OtpInputField(
                  context: context,
                  isDark: isDark,
                  controller: _otpController,
                  onChanged: _updateOtpValue,
                  onCompleted: (value) => setState(() => _otpValue = value),
                ),
                SizedBox(height: verticalSpacing * 2),
                ResendOtpRow(
                  timeRemaining: timeRemaining,
                  isDark: isDark,
                  onResendOtp: onResendOtp,
                ),
                SizedBox(height: verticalSpacing * 2),
                AppButton(
                  text: LocaleKeys.verify.tr(),
                  backgroundColor: AppColors.primary,
                  textColor: Colors.black,
                  isLoading: isLoading,
                  onPressed: onVerifyOtp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}