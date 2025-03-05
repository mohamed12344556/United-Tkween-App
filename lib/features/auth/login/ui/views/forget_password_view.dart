import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/forget_password_cubit/forget_password_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/widgets/auth_header.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  // التحكم المحلي لصفحة استعادة كلمة المرور
  final TextEditingController _localOtpController = TextEditingController();
  String _otpValue = '';

  @override
  void dispose() {
    // تأكد من أن الحالة ما زالت مرتبطة بشجرة الواجهة قبل التخلص من وحدة التحكم
    _localOtpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive values
    final horizontalPadding = context.screenWidth * 0.06;
    final verticalSpacing = context.screenHeight * 0.02;
    final isDark = context.isDarkMode;

    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordError) {
          context.showErrorSnackBar(state.message);
        } else if (state is ForgetPasswordOtpSent) {
          // عندما يتم إرسال OTP بنجاح، لا تنتقل بعيدًا
          context.showSuccessSnackBar(LocaleKeys.otp_sent_successfully.tr());

          // تنظيف حقل الإدخال - تأكد من أن الحالة لا تزال مرتبطة قبل تنظيف وحدة التحكم
          if (mounted) {
            setState(() {
              _localOtpController.clear();
              _otpValue = '';
            });
          }
        } else if (state is ForgetPasswordSuccess) {
          // إعادة تعيين كلمة المرور بنجاح، العودة إلى تسجيل الدخول
          context.showSuccessSnackBar(
            LocaleKeys.password_reset_successful.tr(),
          );
          context.pushNamedAndRemoveUntil(
            Routes.loginView,
            predicate: (route) => false,
          );
        } else if (state is ForgetPasswordOtpResent) {
          // عند إعادة إرسال OTP - تأكد من أن الحالة لا تزال مرتبطة قبل تنظيف وحدة التحكم
          if (mounted) {
            setState(() {
              _localOtpController.clear();
              _otpValue = '';
            });
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<ForgetPasswordCubit>();

        // تحديد أي شاشة لعرضها بناءً على الحالة
        Widget content;

        if (state is ForgetPasswordOtpSent ||
            state is ForgetPasswordOtpTimerUpdated) {
          // عرض شاشة التحقق من OTP
          content = _buildOtpVerificationScreen(context, cubit, state);
        } else if (state is ForgetPasswordOtpVerified) {
          // عرض شاشة إعادة تعيين كلمة المرور
          content = _buildPasswordResetScreen(context, cubit);
        } else {
          // عرض شاشة طلب OTP (الافتراضية)
          content = _buildRequestOtpScreen(context, cubit, state);
        }

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
              onPressed: () {
                Navigator.of(context).pop();
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
                child: content,
              ),
            ),
          ),
        );
      },
    );
  }

  // شاشة طلب OTP (الخطوة الأولى)
  Widget _buildRequestOtpScreen(
    BuildContext context,
    ForgetPasswordCubit cubit,
    ForgetPasswordState state,
  ) {
    final verticalSpacing = context.screenHeight * 0.02;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        AuthHeader(
          title: LocaleKeys.forgot_password.tr(),
          subtitle:
              LocaleKeys.enter_your_email_address_to_reset_your_password.tr(),
        ),

        // حقل إدخال البريد الإلكتروني
        AppTextField(
          controller: cubit.emailController,
          hintText: LocaleKeys.email.tr(),
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: verticalSpacing * 2),

        // زر طلب OTP
        AppButton(
          text: LocaleKeys.get_verification_code.tr(),
          backgroundColor: AppColors.primary,
          textColor: Colors.black,
          isLoading: state is ForgetPasswordLoading,
          onPressed: () {
            cubit.requestOtp(email: cubit.emailController.text.trim());
          },
        ),
      ],
    );
  }

  // شاشة التحقق من OTP (الخطوة الثانية)
  Widget _buildOtpVerificationScreen(
    BuildContext context,
    ForgetPasswordCubit cubit,
    ForgetPasswordState state,
  ) {
    final verticalSpacing = context.screenHeight * 0.02;
    final horizontalPadding = context.screenWidth * 0.06;
    final isDark = context.isDarkMode;
    final email = cubit.currentEmail ?? '';
    int timeRemaining = 0;

    if (state is ForgetPasswordOtpTimerUpdated) {
      timeRemaining = state.timeRemaining;
    } else if (state is ForgetPasswordOtpSent) {
      timeRemaining = cubit.otpTimeRemaining;
    }

    return Column(
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

        // إظهار البريد الإلكتروني
        Padding(
          padding: EdgeInsets.only(bottom: verticalSpacing),
          child: Text(
            email,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: context.screenWidth * 0.04,
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),

        SizedBox(height: verticalSpacing),

        // حقل إدخال OTP باستخدام pin_code_fields
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                  context.screenWidth * 0.14, // حجم أكبر قليلاً للمربعات
              fieldWidth: context.screenWidth * 0.14,

              // ألوان مُحسّنة لحقول PIN
              activeFillColor:
                  context.isDarkMode ? AppColors.darkSecondary : Colors.white,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // توزيع متساوٍ
            backgroundColor: Colors.transparent,

            // تنسيق النص داخل الحقول
            textStyle: TextStyle(
              fontSize: 20, // خط أكبر للأرقام
              fontWeight: FontWeight.bold,
              color: context.isDarkMode ? Colors.white : Colors.black,
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
                  RegExp(r'^\d{4}$').hasMatch(text); // تحقق أفضل من الأرقام
            },
          ),
        ),

        SizedBox(height: verticalSpacing * 2),

        // زر إعادة إرسال OTP مع العداد
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${LocaleKeys.didnt_receive_code.tr()} ',
              style: TextStyle(
                fontSize: context.screenWidth * 0.035,
                color: context.isDarkMode ? Colors.grey[300] : Colors.black54,
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

        // زر التحقق
        AppButton(
          text: LocaleKeys.verify.tr(),
          backgroundColor: AppColors.primary,
          textColor: Colors.black,
          isLoading: state is ForgetPasswordLoading,
          onPressed: () {
            cubit.verifyOtp(otp: _otpValue, email: email);
          },
        ),
      ],
    );
  }

  // شاشة إعادة تعيين كلمة المرور (الخطوة النهائية)
  Widget _buildPasswordResetScreen(
    BuildContext context,
    ForgetPasswordCubit cubit,
  ) {
    final verticalSpacing = context.screenHeight * 0.02;
    final email = cubit.currentEmail ?? '';
    final otp = cubit.verifiedOtp ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        AuthHeader(
          title: LocaleKeys.reset_password.tr(),
          subtitle: LocaleKeys.create_a_new_password_for_your_account.tr(),
        ),

        // حقل كلمة المرور
        AppTextField(
          controller: cubit.passwordController,
          hintText: LocaleKeys.new_password.tr(),
          isPassword: true,
          passwordVisible: cubit.isPasswordVisible,
          onTogglePasswordVisibility: () {
            cubit.togglePasswordVisibility();
          },
        ),

        SizedBox(height: verticalSpacing),

        // حقل تأكيد كلمة المرور
        AppTextField(
          controller: cubit.confirmPasswordController,
          hintText: LocaleKeys.confirm_new_password.tr(),
          isPassword: true,
          passwordVisible: cubit.isConfirmPasswordVisible,
          onTogglePasswordVisibility: () {
            cubit.toggleConfirmPasswordVisibility();
          },
        ),

        SizedBox(height: verticalSpacing * 2),

        // زر إعادة تعيين كلمة المرور
        AppButton(
          text: LocaleKeys.reset_password.tr(),
          backgroundColor: AppColors.primary,
          textColor: Colors.black,
          isLoading:
              false, // متغير state غير معرف في هذه الدالة، لذلك نستخدم قيمة ثابتة false هنا
          onPressed: () {
            cubit.resetPassword(
              email: email,
              otp: otp,
              password: cubit.passwordController.text,
              confirmPassword: cubit.confirmPasswordController.text,
            );
          },
        ),
      ],
    );
  }
}
