import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class AppLogo extends StatelessWidget {
  final double? size;
  final IconData icon;
  final bool isCircle;

  const AppLogo({
    super.key,
    this.size,
    this.icon = Icons.auto_awesome,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final containerSize = size ?? context.screenWidth * 0.13;
    final iconSize = containerSize * 0.55;
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.all(Radius.circular(15)),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: AppColors.black38,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Icon(
        icon,
        color: isDark ? AppColors.text : AppColors.textSecondary,
        size: iconSize,
      ),
    );
  }
}
