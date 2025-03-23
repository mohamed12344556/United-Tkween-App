import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/core.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const SocialButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final defaultBackgroundColor =
        isDark
            ? backgroundColor ?? AppColors.darkSecondary
            : backgroundColor ?? AppColors.secondary;

    final defaultTextColor = textColor ?? AppColors.textHint;

    final iconColor = AppColors.textHint;

    return SizedBox(
      width: double.infinity,
      height: context.screenHeight * 0.065,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: defaultBackgroundColor,
          foregroundColor: defaultTextColor,
          padding: EdgeInsets.symmetric(vertical: context.screenHeight * 0.015),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.screenWidth * 0.03),
          ),
          elevation: 1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: context.screenWidth * 0.05,
              height: context.screenWidth * 0.05,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            SizedBox(width: 10.w),
            SizedBox(
              width: 190.w,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: context.screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: defaultTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
