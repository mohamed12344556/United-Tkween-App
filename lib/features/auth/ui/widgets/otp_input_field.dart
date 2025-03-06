import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:united_formation_app/core/core.dart';

class OtpInputField extends StatelessWidget {
  final BuildContext context;
  final bool isDark;
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String) onCompleted;

  const OtpInputField({
    super.key,
    required this.context,
    required this.isDark,
    required this.controller,
    required this.onChanged,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    // التحقق من أن السياق متصل
    if (!context.mounted) return const SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.06),
      child: PinCodeTextField(
        appContext: context,
        length: 4,
        obscureText: false,
        animationType: AnimationType.fade,
        controller: controller,
        keyboardType: TextInputType.number,
        enableActiveFill: true,
        cursorColor: AppColors.primary,
        autoFocus: true,
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
          // التحقق من أن السياق متصل قبل إجراء أي عملية إكمال
          if (context.mounted) {
            onCompleted(value);
          }
        },
        onChanged: (value) {
          // التحقق من أن السياق متصل قبل إجراء أي تغيير
          if (context.mounted) {
            onChanged(value);
          }
        },
        beforeTextPaste: (text) =>
            text != null &&
            text.length == 4 &&
            RegExp(r'^\d{4}$').hasMatch(text),
      ),
    );
  }
}