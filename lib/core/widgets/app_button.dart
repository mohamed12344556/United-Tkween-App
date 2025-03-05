import 'package:flutter/material.dart';
import '../core.dart';

class AppButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final bool isLoading;
  final double? height;
  final double? borderRadius;
  final Widget? child; 
  final double? elevation; 
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.isLoading = false,
    this.height,
    this.borderRadius,
    this.child,
    this.elevation,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final responsiveFontSize = context.screenWidth * 0.04;
    final responsiveHeight = height ?? context.screenHeight * 0.065;
    final responsiveBorderRadius = borderRadius ?? context.screenWidth * 0.03;
    final loaderSize = context.screenWidth * 0.04;
    final spacingSize = context.screenWidth * 0.02;

    final defaultBackgroundColor =
        isDark
            ? backgroundColor ?? AppColors.primary
            : backgroundColor ?? AppColors.primary;

    final defaultTextColor =
        isDark ? textColor ?? Colors.black87 : textColor ?? Colors.black;

    final buttonElevation = elevation ?? (isDark ? 3 : 2);

    return SizedBox(
      width: width ?? double.infinity,
      height: responsiveHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: defaultBackgroundColor,
          foregroundColor: defaultTextColor,
          disabledBackgroundColor: defaultBackgroundColor.withValues(
            alpha: isDark ? 0.6 : 0.7,
          ),
          disabledForegroundColor: defaultTextColor.withValues(alpha: 0.7),
          padding:
              padding ??
              EdgeInsets.symmetric(vertical: context.screenHeight * 0.015),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsiveBorderRadius),
          ),
          elevation: buttonElevation,
          shadowColor: defaultBackgroundColor.withValues(alpha: 0.4),
        ),
        child:
            isLoading
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: loaderSize,
                      width: loaderSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: defaultTextColor,
                      ),
                    ),
                    SizedBox(width: spacingSize),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: responsiveFontSize,
                        color: defaultTextColor,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                )
                : child ??
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: responsiveFontSize,
                        color: defaultTextColor,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        letterSpacing: 0.3,
                      ),
                    ),
      ),
    );
  }
}
