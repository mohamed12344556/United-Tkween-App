import 'package:flutter/material.dart';
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
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: isDark ? Colors.black87 : Colors.black,
                size: context.screenWidth * 0.05,
              ),
            if (isSelected) SizedBox(width: context.screenWidth * 0.02),
            Text(
              label,
              style: TextStyle(
                fontSize: context.screenWidth * 0.035,
                color:
                    isDark
                        ? (isSelected ? Colors.black87 : Colors.white)
                        : Colors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
