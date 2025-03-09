import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class SelectionOptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionOptionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // تهيئة الأحجام المتجاوبة
    context.initResponsive();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // تحديد القيم المتجاوبة حسب نوع الجهاز
    final verticalPadding = context.isTablet ? 10.h : 8.h;
    final horizontalPadding = context.isTablet ? 20.w : 16.w;
    final borderRadius = context.isTablet ? 16.r : 12.r;
    final fontSize = context.isTablet ? 16.sp : 14.sp;
    final iconSize = context.isTablet ? 18.r : 14.r;
    final iconSpacing = context.isTablet ? 10.w : 6.w;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.selectedChip
                  : (isDark ? AppColors.darkSurface : AppColors.unselectedChip),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.selectedChip.withValues(alpha: 0.7)
                    : (isDark ? AppColors.darkSecondary : AppColors.border),
            width: 1,
          ),
          boxShadow:
              isSelected && !isDark
                  ? [
                    BoxShadow(
                      color: AppColors.selectedChip.withValues(alpha: 0.2),
                      blurRadius: 4.r,
                      offset: Offset(0, 2.h),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center, // تمركز المحتوى أفقيًا
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: isSelected ? 1.0 : 0.0,
              child: Icon(
                Icons.check_circle,
                color: isDark ? AppColors.text : AppColors.text,
                size: iconSize,
              ),
            ),
            if (isSelected) SizedBox(width: iconSpacing),
            Flexible(
              child: Center(
                // توسيط النص
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontSize: fontSize,
                    color:
                        isSelected
                            ? (isDark ? AppColors.text : AppColors.text)
                            : (isDark
                                ? AppColors.textSecondary
                                : AppColors.text),
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center, // محاذاة النص للمركز
                  child: Text(
                    label,
                    textAlign: TextAlign.center, // تأكيد على توسيط النص
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
