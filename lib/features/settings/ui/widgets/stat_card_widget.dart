import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isResponsive;
  final bool isVertical;

  const StatCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isResponsive = false, // غير متجاوب افتراضيًا
    this.isVertical = false, // أفقي افتراضيًا
  });

  @override
  Widget build(BuildContext context) {
    // تحديد القيم المتجاوبة
    final titleFontSize = isResponsive 
        ? (context.isTablet ? 14.sp : 12.sp) 
        : 12.0;
    final valueFontSize = isResponsive 
        ? (context.isTablet ? 22.sp : 18.sp) 
        : 18.0;
    final iconSize = isResponsive 
        ? (context.isTablet ? 28.r : 24.r) 
        : 24.0;
    final verticalSpacing = isResponsive 
        ? (context.isTablet ? 10.h : 8.h) 
        : 8.0;
    final horizontalSpacing = isResponsive 
        ? (context.isTablet ? 10.w : 8.w) 
        : 8.0;
    final cardPadding = isResponsive 
        ? EdgeInsets.symmetric(
            vertical: context.isTablet ? 20.h : 16.h,
            horizontal: context.isTablet ? 12.w : 8.w,
          )
        : const EdgeInsets.symmetric(vertical: 16, horizontal: 8);
    final cardBorderRadius = isResponsive ? 16.r : 16.0;

    // اختيار التخطيط بناءً على الاتجاه
    if (isVertical) {
      return _buildVerticalLayout(
        context,
        titleFontSize,
        valueFontSize,
        iconSize,
        verticalSpacing,
        horizontalSpacing,
        cardPadding,
        cardBorderRadius,
      );
    } else {
      return _buildHorizontalLayout(
        context,
        titleFontSize,
        valueFontSize,
        iconSize,
        verticalSpacing,
        cardPadding,
        cardBorderRadius,
      );
    }
  }

  // التخطيط الأفقي - الافتراضي
  Widget _buildHorizontalLayout(
    BuildContext context,
    double titleFontSize,
    double valueFontSize,
    double iconSize,
    double verticalSpacing,
    EdgeInsetsGeometry cardPadding,
    double cardBorderRadius,
  ) {
    return Expanded(
      child: Container(
        padding: cardPadding,
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: iconSize),
            SizedBox(height: verticalSpacing),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: valueFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: verticalSpacing / 2),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[400], 
                fontSize: titleFontSize
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // التخطيط الرأسي - للوضع الرأسي في بطاقة الإحصائيات
  Widget _buildVerticalLayout(
    BuildContext context,
    double titleFontSize,
    double valueFontSize,
    double iconSize,
    double verticalSpacing,
    double horizontalSpacing,
    EdgeInsetsGeometry cardPadding,
    double cardBorderRadius,
  ) {
    return Container(
      width: double.infinity, // استخدام العرض الكامل
      padding: cardPadding,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: iconSize),
          SizedBox(width: horizontalSpacing * 1.5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[400], 
                    fontSize: titleFontSize
                  ),
                ),
                SizedBox(height: verticalSpacing / 2),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}