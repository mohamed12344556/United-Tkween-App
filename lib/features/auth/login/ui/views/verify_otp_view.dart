import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/forget_password_cubit/forget_password_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/otp_cubit/otp_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/widgets/auth_header.dart';
import 'package:united_formation_app/features/auth/login/ui/widgets/forget_password_handler.dart';
import 'package:united_formation_app/features/auth/login/ui/widgets/otp_input_field.dart';
import 'package:united_formation_app/features/auth/login/ui/widgets/resend_otp_row.dart';
import 'package:united_formation_app/features/auth/login/ui/widgets/signup_otp_handler.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

class VerifyOtpView extends StatefulWidget {
  final String email;

  const VerifyOtpView({super.key, required this.email});

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  final TextEditingController _otpController = TextEditingController();
  String _otpValue = '';
  bool _isMounted = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initOtpProcess();
    });
  }

  void _initOtpProcess() {
    if (context.read<ForgetPasswordCubit?>() != null) {
      context.read<ForgetPasswordCubit>().requestOtp(email: widget.email);
    } else if (context.read<OtpCubit?>() != null) {
      final otpCubit = context.read<OtpCubit>();
      if (otpCubit.otpTimeRemaining <= 0) otpCubit.resendOtp();
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (_isMounted) super.setState(fn);
  }

  @override
  void dispose() {
    _isMounted = false;
    _disposeCubits();
    _otpController.dispose();
    super.dispose();
  }

  void _disposeCubits() {
    try {
      context.read<OtpCubit?>()?.cancelTimer();
      context.read<ForgetPasswordCubit?>()?.cancelTimer();
    } catch (e) {
      print('Error disposing cubits: $e');
    }
  }

  void _updateOtpValue(String value) {
    if (_isMounted) setState(() => _otpValue = value);
  }

  @override
  Widget build(BuildContext context) {
    final verticalSpacing = context.screenHeight * 0.02;
    final horizontalPadding = context.screenWidth * 0.06;
    final isDark = context.isDarkMode;
    final isOtpCubit = context.read<ForgetPasswordCubit?>() == null;

    return isOtpCubit
        ? SignupOtpHandler.buildBlocConsumer(
          context: context,
          verticalSpacing: verticalSpacing,
          horizontalPadding: horizontalPadding,
          isDark: isDark,
          otpController: _otpController,
          otpValue: _otpValue,
          updateOtpValue: _updateOtpValue,
          buildScaffold: _buildScaffold,
        )
        : ForgetPasswordHandler.buildBlocConsumer(
          context: context,
          verticalSpacing: verticalSpacing,
          horizontalPadding: horizontalPadding,
          isDark: isDark,
          email: widget.email,
          otpController: _otpController,
          otpValue: _otpValue,
          updateOtpValue: _updateOtpValue,
          buildScaffold: _buildScaffold,
        );
  }

  Widget _buildScaffold(
    BuildContext context,
    double verticalSpacing,
    double horizontalPadding,
    bool isDark,
    int timeRemaining,
    bool isLoading,
    Function() onResendOtp,
    Function() onVerifyOtp,
  ) {
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
