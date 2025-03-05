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
    final isDark = context.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkSecondary : Colors.white),
          borderRadius: BorderRadius.circular(context.screenWidth * 0.08),
          border: Border.all(
            color:
                isDark
                    ? (isSelected
                        ? AppColors.primary.withValues(alpha: 0.7)
                        : Colors.grey.shade700)
                    : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow:
              isSelected && !isDark
                  ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
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
                color: isDark ? Colors.black87 : Colors.black,
                size: context.screenWidth * 0.05,
              ),
            ),
            // if (isSelected) SizedBox(width: context.screenWidth * 0.02),
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: 14.5.sp,
                  color:
                      isDark
                          ? (isSelected ? Colors.black87 : Colors.white)
                          : Colors.black,
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
