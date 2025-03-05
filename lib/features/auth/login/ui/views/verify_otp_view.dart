import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/forget_password_cubit/forget_password_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/otp_cubit/otp_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/widgets/auth_header.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

class VerifyOtpView extends StatefulWidget {
  final String email;

  const VerifyOtpView({super.key, required this.email});

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  final TextEditingController _localOtpController = TextEditingController();
  String _otpValue = '';

  // تتبع حالة الـ mounted
  bool _isMounted = true;

  @override
  void initState() {
    super.initState();

    // استخدم PostFrameCallback لتأخير طلب OTP حتى تكتمل عملية البناء
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _initOtpProcess();
    });
  }

  // طريقة منفصلة لبدء عملية OTP
  void _initOtpProcess() {
    if (!mounted) return;

    if (context.read<ForgetPasswordCubit?>() != null) {
      // طلب OTP جديد لتشغيل المؤقت
      final email = widget.email;
      context.read<ForgetPasswordCubit>().requestOtp(email: email);
    } else if (context.read<OtpCubit?>() != null) {
      // اعتبر أن OtpCubit يبدأ المؤقت تلقائياً في البناء
      // لكن يمكنك أيضًا إعادة طلب OTP إذا كان المؤقت متوقفًا
      final otpCubit = context.read<OtpCubit>();
      if (otpCubit.otpTimeRemaining <= 0) {
        otpCubit.resendOtp();
      }
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (_isMounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    // تعيين علامة التخلص أولاً
    _isMounted = false;

    // إلغاء المؤقتات أولاً ثم التخلص من وحدة التحكم
    try {
      final otpCubit = context.read<OtpCubit?>();
      if (otpCubit != null) {
        otpCubit.cancelTimer();
      }
    } catch (e) {
      print('Error canceling OtpCubit timer: $e');
    }

    try {
      final forgetCubit = context.read<ForgetPasswordCubit?>();
      if (forgetCubit != null) {
        forgetCubit.cancelTimer();
      }
    } catch (e) {
      print('Error canceling ForgetPasswordCubit timer: $e');
    }

    // التخلص من وحدة تحكم OTP بعد إلغاء المؤقتات
    try {
      _localOtpController.dispose();
    } catch (e) {
      print('Error disposing OTP controller: $e');
    }

    super.dispose();
  }

  // استخدام دالة آمنة لتحديث قيمة OTP
  void _safeUpdateOtpValue(String value) {
    if (_isMounted) {
      setState(() {
        _otpValue = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final verticalSpacing = context.screenHeight * 0.02;
    final horizontalPadding = context.screenWidth * 0.06;
    final isDark = context.isDarkMode;

    // تحديد نوع الـ BLoC الذي نستخدمه
    final isOtpCubit = context.read<ForgetPasswordCubit?>() == null;

    // للتبسيط، سأستخدم مقاربة مشتركة لكلا النوعين من الـ BLoC
    return isOtpCubit
        ? _buildWithOtpCubit(
          context,
          verticalSpacing,
          horizontalPadding,
          isDark,
        )
        : _buildWithForgetPasswordCubit(
          context,
          verticalSpacing,
          horizontalPadding,
          isDark,
        );
  }

  // بناء الواجهة باستخدام OtpCubit (للتحقق من الحساب الجديد)
  Widget _buildWithOtpCubit(
    BuildContext context,
    double verticalSpacing,
    double horizontalPadding,
    bool isDark,
  ) {
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        if (!mounted) return;

        if (state is OtpError) {
          context.showErrorSnackBar(state.message);
        } else if (state is OtpVerified) {
          context.showSuccessSnackBar(
            LocaleKeys.otp_verified_successfully.tr(),
          );

          // تأكد من إلغاء المؤقت مرة أخرى قبل الانتقال
          try {
            final cubit = context.read<OtpCubit>();
            cubit.cancelTimer();
          } catch (e) {
            // تجاهل الأخطاء
            print('Error canceling timer before navigation: $e');
          }

          // استخدم Future.delayed مع Duration.zero للسماح بإكمال العمليات الحالية
          Future.delayed(Duration.zero, () {
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.learningOptionsView,
                (route) => false,
              );
            }
          });
        } else if (state is OtpResent) {
          context.showSuccessSnackBar(LocaleKeys.otp_resent_successfully.tr());
          if (mounted) {
            setState(() {
              _localOtpController.clear();
              _otpValue = '';
            });
          }
        }
      },
      builder: (context, state) {
        if (!mounted) return const SizedBox();

        final cubit = context.read<OtpCubit>();
        final timeRemaining =
            (state is OtpTimerUpdated)
                ? state.timeRemaining
                : cubit.otpTimeRemaining;

        return _buildScaffold(
          context,
          verticalSpacing,
          horizontalPadding,
          isDark,
          timeRemaining,
          state is OtpLoading,
          () {
            if (mounted) cubit.resendOtp();
          },
          () {
            if (mounted) cubit.verifyOtp(otp: _otpValue);
          },
        );
      },
    );
  }

  // بناء الواجهة باستخدام ForgetPasswordCubit (لاستعادة كلمة المرور)
  // بناء الواجهة باستخدام ForgetPasswordCubit (لاستعادة كلمة المرور)
  Widget _buildWithForgetPasswordCubit(
    BuildContext context,
    double verticalSpacing,
    double horizontalPadding,
    bool isDark,
  ) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (!mounted) return;

        print("ForgetPasswordCubit state: $state");

        if (state is ForgetPasswordError) {
          context.showErrorSnackBar(state.message);
        } else if (state is ForgetPasswordOtpVerified) {
          context.showSuccessSnackBar(
            LocaleKeys.otp_verified_successfully.tr(),
          );

          // تأكد من إلغاء المؤقت قبل الانتقال
          try {
            final cubit = context.read<ForgetPasswordCubit>();
            cubit.cancelTimer();
          } catch (e) {
            print('Error canceling timer before navigation: $e');
          }

          // تأكد من تخزين OTP المتحقق منه
          final verifiedOtp = context.read<ForgetPasswordCubit>().verifiedOtp;
          print("Verified OTP before navigation: $verifiedOtp");

          // استخدام تأخير لضمان الانتقال بعد اكتمال العمليات الحالية
          Future.delayed(Duration.zero, () {
            if (mounted) {
              // استخدام النداء الصحيح لـ context.pushNamed
              context.pushNamed(
                Routes.resetPasswordView,
                arguments: {
                  'email': widget.email,
                  'otp':
                      verifiedOtp ?? _otpValue, // استخدم _otpValue كخطة بديلة
                },
              );
            }
          });
        } else if (state is ForgetPasswordOtpResent) {
          context.showSuccessSnackBar(LocaleKeys.otp_resent_successfully.tr());
          if (mounted) {
            setState(() {
              _localOtpController.clear();
              _otpValue = '';
            });
          }
        }
      },
      builder: (context, state) {
        if (!mounted) return const SizedBox();

        final cubit = context.read<ForgetPasswordCubit>();
        int timeRemaining = 0;
        if (state is ForgetPasswordOtpTimerUpdated) {
          timeRemaining = state.timeRemaining;
        } else {
          timeRemaining = cubit.otpTimeRemaining;
        }

        return _buildScaffold(
          context,
          verticalSpacing,
          horizontalPadding,
          isDark,
          timeRemaining,
          state is ForgetPasswordLoading,
          () {
            if (mounted) cubit.resendOtp();
          },
          () {
            if (mounted) {
              print("Verifying OTP: $_otpValue for email: ${widget.email}");
              cubit.verifyOtp(otp: _otpValue, email: widget.email);
            }
          },
        );
      },
    );
  }

  // بناء الواجهة العامة المشتركة لكلا النوعين
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
                    widget.email,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: context.screenWidth * 0.04,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),

                SizedBox(height: verticalSpacing),

                // حقل إدخال OTP
                _buildPinCodeTextField(context, isDark),

                SizedBox(height: verticalSpacing * 2),

                // زر إعادة إرسال OTP مع العداد
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
                        onPressed: onResendOtp,
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
                  isLoading: isLoading,
                  onPressed: () {
                    if (mounted) {
                      onVerifyOtp();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // طريقة منفصلة لبناء حقل إدخال OTP
  Widget _buildPinCodeTextField(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.06),
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
        // استخدم مفتاح ثابت بدلاً من مفتاح ديناميكي
        key: const ValueKey('otp_field'),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(12),
          fieldHeight: context.screenWidth * 0.14,
          fieldWidth: context.screenWidth * 0.14,
          activeFillColor: isDark ? AppColors.darkSecondary : Colors.white,
          inactiveFillColor:
              isDark ? AppColors.darkSecondary : Colors.grey.shade50,
          selectedFillColor:
              isDark ? AppColors.darkSurface : Colors.grey.shade100,
          activeColor: AppColors.primary,
          inactiveColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          selectedColor: AppColors.primary,
          fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 4),
          borderWidth: 1.5,
        ),
        showCursor: true,
        animationDuration: const Duration(milliseconds: 250),
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        backgroundColor: Colors.transparent,
        textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
        onCompleted: (value) {
          // فقط تحديث قيمة OTP ولا تستدعي التحقق هنا تلقائيًا
          if (mounted) {
            setState(() {
              _otpValue = value;
            });
          }
        },
        onChanged: (value) {
          _safeUpdateOtpValue(value);
        },
        beforeTextPaste: (text) {
          if (text == null) return false;
          return text.length == 4 && RegExp(r'^\d{4}$').hasMatch(text);
        },
      ),
    );
  }
}
