import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final Color? iconColor;
  // إضافة خصائص للتحكم في التجاوبية
  final double? iconSize;
  final double? titleSize;
  final double? messageSize;
  final double? buttonWidth;
  final Color? textColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.iconColor,
    this.iconSize,
    this.titleSize,
    this.messageSize,
    this.buttonWidth,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final finalIconColor = iconColor ?? AppColors.primary;

    // استخدام الأحجام المتجاوبة أو الافتراضية
    final finalIconSize = iconSize ?? 50.r;
    final finalTitleSize = titleSize ?? 20.sp;
    final finalMessageSize = messageSize ?? 16.sp;
    final finalButtonWidth = buttonWidth ?? 200.w;

    return Center(
      child: Padding(
        padding: 32.paddingAll,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: context.isTablet ? 120.r : 100.r,
              height: context.isTablet ? 120.r : 100.r,
              decoration: BoxDecoration(
                color: AppColors.unselectedChip,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Icon(icon, size: finalIconSize, color: finalIconColor),
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: TextStyle(
                fontSize: finalTitleSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              style: TextStyle(
                fontSize: finalMessageSize,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              SizedBox(height: 32.h),
              SizedBox(
                width: finalButtonWidth,
                height: context.isTablet ? 54.h : 48.h,
                child: ElevatedButton.icon(
                  onPressed: onButtonPressed,
                  icon: Icon(
                    Icons.add_shopping_cart,
                    size: context.isTablet ? 20.r : 16.r,
                  ),
                  label: Text(
                    buttonText!,
                    style: TextStyle(
                      fontSize: context.isTablet ? 16.sp : 14.sp,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.unselectedChip,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
