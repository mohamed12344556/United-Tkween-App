import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/generated/locale_keys.g.dart';

class ResendOtpRow extends StatelessWidget {
  final int timeRemaining;
  final bool isDark;
  final VoidCallback onResendOtp;

  const ResendOtpRow({
    super.key,
    required this.timeRemaining,
    required this.isDark,
    required this.onResendOtp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.didnt_receive_code.tr(),
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
    );
  }
}