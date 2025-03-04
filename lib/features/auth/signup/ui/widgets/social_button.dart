import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:united_formation_app/core/core.dart';

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
            : backgroundColor ?? Colors.black;

    final defaultTextColor =
        isDark ? textColor ?? Colors.white : textColor ?? Colors.white;

    final iconColor =
        isDark ? Colors.white.withValues(alpha: 0.9) : Colors.white;

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
          elevation: isDark ? 4 : 1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: context.screenWidth * 0.05,
              height: context.screenWidth * 0.05,
              color: iconColor,
            ),
            SizedBox(width: context.screenWidth * 0.03),
            Text(
              text,
              style: TextStyle(
                fontSize: context.screenWidth * 0.04,
                fontWeight: FontWeight.w500,
                color: defaultTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
