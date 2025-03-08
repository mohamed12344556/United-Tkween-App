import 'package:flutter/material.dart';
import 'package:united_formation_app/core/core.dart';

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
          context.localeS.didnt_receive_code,
          style: TextStyle(
            fontSize: context.screenWidth * 0.035,
            color: isDark ? AppColors.textHint : AppColors.textSecondary,
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
              context.localeS.resend,
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