import 'package:flutter/material.dart';
import 'package:united_formation_app/core/core.dart';

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
        boxShadow:
            isDark
                ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
                : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
      ),
      child: Icon(
        icon,
        color: isDark ? Colors.black87 : Colors.black,
        size: iconSize,
      ),
    );
  }
}
