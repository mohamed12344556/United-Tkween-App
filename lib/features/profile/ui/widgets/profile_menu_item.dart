import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color highlightColor;
  final Color iconBackgroundColor;
  final bool isHighlighted;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.backgroundColor = Colors.transparent,
    this.highlightColor = AppColors.primary,
    this.iconBackgroundColor = Colors.white,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color:
            isHighlighted
                ? highlightColor.withValues(alpha: isDarkMode ? 0.2 : 0.8)
                : backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          splashColor: highlightColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              textDirection: Directionality.of(context),
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color:
                        isHighlighted
                            ? isDarkMode
                                ? highlightColor
                                : AppColors.secondary
                            : isDarkMode
                            ? Colors.white
                            : AppColors.text,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          isHighlighted
                              ? isDarkMode
                                  ? highlightColor
                                  : AppColors.secondary
                              : isDarkMode
                              ? Colors.white
                              : AppColors.text,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color:
                      isHighlighted
                          ? isDarkMode
                              ? highlightColor
                              : AppColors.secondary
                          : isDarkMode
                          ? Colors.white70
                          : AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
