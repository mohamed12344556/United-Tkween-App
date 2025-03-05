import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/otp_cubit/otp_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/widgets/auth_header.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

class OtpView extends StatefulWidget {
  final String email;

  const OtpView({super.key, required this.email});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  // استخدام متغير String بدلاً من TextEditingController لتخزين قيمة OTP
  String _otpValue = '';
  final TextEditingController _localOtpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start the timer when the view is created
    context.read<OtpCubit>().initTimer();
  }

  @override
  void dispose() {
    // التأكد من التخلص من وحدة التحكم بشكل آمن
    _localOtpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive values
    final horizontalPadding = context.screenWidth * 0.06;
    final verticalSpacing = context.screenHeight * 0.02;

    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is OtpError) {
          context.showErrorSnackBar(state.message);
        } else if (state is OtpVerified) {
          // OTP verification successful
          context.showSuccessSnackBar(
            LocaleKeys.otp_verified_successfully.tr(),
          );

          // Navigate to learning options view after successful OTP verification
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.learningOptionsView,
            (route) => false,
          );
        } else if (state is OtpResent) {
          context.showSuccessSnackBar(LocaleKeys.otp_resent_successfully.tr());
          // Reset OTP field when code is resent - تأكد من أن الحالة لا تزال مرتبطة
          if (mounted) {
            setState(() {
              _localOtpController.clear();
              _otpValue = '';
            });
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<OtpCubit>();
        final isDark = context.isDarkMode;
        final timeRemaining =
            (state is OtpTimerUpdated)
                ? state.timeRemaining
                : cubit.otpTimeRemaining;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      title: LocaleKeys.verify_your_email.tr(),
                      subtitle:
                          LocaleKeys
                              .please_enter_the_4_digit_code_sent_to_your_email_address
                              .tr(),
                    ),

                    // Show email
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

                    // OTP input fields using pin_code_fields
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        controller: _localOtpController,
                        keyboardType: TextInputType.number,
                        enableActiveFill: true,
                        cursorColor: AppColors.primary,
                        autoFocus: true,

                        // استخدام مفتاح بسيط لمنع إعادة الإنشاء غير المطلوبة
                        key: ValueKey('otp_field_${timeRemaining}'),

                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight:
                              context.screenWidth *
                              0.14, // حجم أكبر قليلاً للمربعات
                          fieldWidth: context.screenWidth * 0.14,

                          // ألوان مُحسّنة لحقول PIN
                          activeFillColor:
                              context.isDarkMode
                                  ? AppColors.darkSecondary
                                  : Colors.white,
                          inactiveFillColor:
                              context.isDarkMode
                                  ? AppColors.darkSecondary
                                  : Colors.grey.shade50,
                          selectedFillColor:
                              context.isDarkMode
                                  ? AppColors.darkSurface
                                  : Colors.grey.shade100,

                          // تنسيق الحدود بألوان متناسقة
                          activeColor: AppColors.primary,
                          inactiveColor:
                              context.isDarkMode
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                          selectedColor: AppColors.primary,

                          fieldOuterPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ), // تباعد متساوٍ بين المربعات
                          borderWidth: 1.5, // عرض حدود أكبر قليلاً للوضوح
                        ),

                        // التحريك والتأثيرات البصرية
                        showCursor: true,
                        animationDuration: const Duration(milliseconds: 250),
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly, // توزيع متساوٍ
                        backgroundColor: Colors.transparent,

                        // تنسيق النص داخل الحقول
                        textStyle: TextStyle(
                          fontSize: 20, // خط أكبر للأرقام
                          fontWeight: FontWeight.bold,
                          color:
                              context.isDarkMode ? Colors.white : Colors.black,
                        ),

                        // تفاعلات المستخدم
                        onCompleted: (value) {
                          if (mounted) {
                            setState(() {
                              _otpValue = value;
                            });
                            // استدعاء التحقق من الكود
                          }
                        },
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              _otpValue = value;
                            });
                          }
                        },

                        // التحقق من النص الملصق
                        beforeTextPaste: (text) {
                          if (text == null) return false;
                          return text.length == 4 &&
                              RegExp(
                                r'^\d{4}$',
                              ).hasMatch(text); // تحقق أفضل من الأرقام
                        },
                      ),
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Resend OTP timer/button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${LocaleKeys.didnt_receive_code.tr()} ',
                          style: TextStyle(
                            fontSize: context.screenWidth * 0.035,
                            color: isDark ? Colors.grey[300] : Colors.black54,
                          ),
                        ),
                        if (timeRemaining > 0)
                          Text(
                            '${timeRemaining}s',
                            style: TextStyle(
                              fontSize: context.screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          )
                        else
                          TextButton(
                            onPressed: () {
                              cubit.resendOtp();
                            },
                            child: Text(
                              LocaleKeys.resend.tr(),
                              style: TextStyle(
                                fontSize: context.screenWidth * 0.035,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: verticalSpacing * 2),

                    // Verify button
                    AppButton(
                      text: LocaleKeys.verify.tr(),
                      backgroundColor: AppColors.primary,
                      textColor: Colors.black,
                      isLoading: state is OtpLoading,
                      onPressed: () {
                        cubit.verifyOtp(otp: _otpValue);
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
