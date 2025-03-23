import 'package:flutter/material.dart';

import '../core.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
    this.border,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // final CardTheme cardTheme = Theme.of(context).cardTheme;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final cardWidget = Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color ?? (isDarkMode ? AppColors.darkSurface : Colors.white),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: elevation == 0 || elevation == null
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                  blurRadius: elevation! * 4,
                  offset: Offset(0, elevation! * 0.5),
                ),
              ],
        border: border ??
            (isDarkMode
                ? Border.all(color: Colors.grey[800]!, width: 1)
                : Border.all(color: Colors.grey[200]!, width: 1)),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );

    return cardWidget;
  }
}