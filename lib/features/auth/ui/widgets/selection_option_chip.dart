import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:united_formation_app/core/core.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.selectedChip
              : (isDark ? AppColors.darkSurface : AppColors.unselectedChip),
          borderRadius: BorderRadius.circular(context.screenWidth * 0.08),
          border: Border.all(
            color: isSelected
                ? AppColors.selectedChip.withValues(alpha: 0.7)
                : (isDark ? AppColors.darkSecondary : AppColors.border),
            width: 1,
          ),
          boxShadow: isSelected && !isDark
              ? [
                  BoxShadow(
                    color: AppColors.selectedChip.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: isSelected ? 1.0 : 0.0,
              child: Icon(
                Icons.check_circle,
                color: isDark ? AppColors.text : AppColors.text,
                size: context.screenWidth * 0.05,
              ),
            ),
            if (isSelected) SizedBox(width: context.screenWidth * 0.02),
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: 14.5.sp,
                  color: isSelected
                      ? (isDark ? AppColors.text : AppColors.text)
                      : (isDark ? AppColors.textSecondary : AppColors.text),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(label),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
