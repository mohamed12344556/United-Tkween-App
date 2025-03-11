import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../core/utilities/safe_controller.dart';
import '../cubits/otp/otp_cubit.dart';
import '../cubits/password_reset/password_reset_cubit.dart';
import '../widgets/auth_header.dart';
import '../widgets/otp_input_field.dart';
import '../widgets/resend_otp_row.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final SafeTextEditingController _otpController = SafeTextEditingController();
  String _otpValue = '';
  
  // تخزين مراجع للكيوبت لاستخدامها في dispose
  OtpCubit? _otpCubit;
  PasswordResetCubit? _passwordResetCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initOtpProcess();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // تخزين مراجع للكيوبت لاستخدامها في dispose
    try {
      _otpCubit = context.read<OtpCubit?>();
    } catch (e) {
      // OtpCubit not available
    }
    
    try {
      _passwordResetCubit = context.read<PasswordResetCubit?>();
    } catch (e) {
      // PasswordResetCubit not available
    }
  }

  void _initOtpProcess() {
    if (mounted) {
      try {
        if (_passwordResetCubit != null) {
          _passwordResetCubit!.requestOtp(
            email: widget.email,
            context: context,
          );
        } else if (_otpCubit != null) {
          if (_otpCubit!.otpTimeRemaining <= 0) _otpCubit!.resendOtp();
        }
      } catch (e) {
        print('Error initializing OTP process: $e');
      }
    }
  }

  @override
  void dispose() {
    _disposeCubits();

    if (!_otpController.isDisposed) {
      _otpController.dispose();
    }

    super.dispose();
  }

  void _disposeCubits() {
    try {
      // استخدام المراجع المخزنة بدلاً من context.read
      if (_otpCubit != null) {
        _otpCubit!.cancelTimer();
      }
      
      if (_passwordResetCubit != null) {
        _passwordResetCubit!.cancelTimer();
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
    final verticalSpacing = 0.02.sh;
    final horizontalPadding = 0.06.sw;
    final isDark = context.isDarkMode;
    final isAccountVerification = _passwordResetCubit == null;

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
          if (mounted) {
            context.showErrorSnackBar(state.message);
          }
        } else if (state is OtpVerified) {
          if (mounted) {
            context.showSuccessSnackBar(
              context.localeS.otp_verified_successfully,
            );

            Future.microtask(() {
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.learningOptionsView,
                  (route) => false,
                );
              }
            });
          }
        } else if (state is OtpResent) {
          if (mounted) {
            context.showSuccessSnackBar(
              context.localeS.otp_resent_successfully,
            );
            _otpController.clear();
            _updateOtpValue('');
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<OtpCubit>();
        // تحديث المرجع للاستخدام لاحقًا في dispose إذا لزم الأمر
        _otpCubit = cubit;
        
        final timeRemaining =
            state is OtpTimerUpdated
                ? state.timeRemaining
                : cubit.otpTimeRemaining;

        return _buildScaffold(
          timeRemaining: timeRemaining,
          isLoading: state is OtpLoading,
          onResendOtp: () => cubit.resendOtp(),
          onVerifyOtp: () => cubit.verifyOtp(otp: _otpValue, context: context),
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
          if (mounted) {
            context.showErrorSnackBar(state.message);
          }
        } else if (state is PasswordResetOtpVerified) {
          if (mounted) {
            final cubit = context.read<PasswordResetCubit>();
            final verifiedOtp = cubit.verifiedOtp ?? _otpValue;

            cubit.cancelTimer();

            Future.microtask(() {
              if (mounted) {
                context.showSuccessSnackBar(
                  context.localeS.otp_verified_successfully,
                );

                Navigator.of(context).pushReplacementNamed(
                  Routes.resetPasswordView,
                  arguments: {'email': email, 'otp': verifiedOtp},
                );
              }
            });
          }
        } else if (state is PasswordResetOtpResent) {
          if (mounted) {
            context.showSuccessSnackBar(
              context.localeS.otp_resent_successfully,
            );
            _otpController.clear();
            _updateOtpValue('');
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<PasswordResetCubit>();
        // تحديث المرجع للاستخدام لاحقًا في dispose إذا لزم الأمر
        _passwordResetCubit = cubit;
        
        final timeRemaining =
            state is PasswordResetOtpTimerUpdated
                ? state.timeRemaining
                : cubit.otpTimeRemaining;

        return _buildScaffold(
          timeRemaining: timeRemaining,
          isLoading: state is PasswordResetLoading,
          onResendOtp: () => cubit.resendOtp(context),
          onVerifyOtp:
              () => cubit.verifyOtp(
                otp: _otpValue,
                email: email,
                context: context,
              ),
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
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
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
                  title: context.localeS.verify_your_email,
                  subtitle:
                      context
                          .localeS
                          .please_enter_the_4_digit_code_sent_to_your_email_address,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: verticalSpacing),
                  child: Text(
                    widget.email,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 0.04.sw,
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
                  onCompleted: (value) {
                    if (mounted) {
                      setState(() => _otpValue = value);
                    }
                  },
                ),
                SizedBox(height: verticalSpacing * 2),
                ResendOtpRow(
                  timeRemaining: timeRemaining,
                  isDark: isDark,
                  onResendOtp: onResendOtp,
                ),
                SizedBox(height: verticalSpacing * 2),
                AppButton(
                  text: context.localeS.verify,
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