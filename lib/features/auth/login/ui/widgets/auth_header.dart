import 'package:flutter/material.dart';
import '../../../../../core/core.dart';
import 'app_logo.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? logoIcon;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final verticalSpacing = context.screenHeight * 0.02;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        AppLogo(icon: logoIcon ?? Icons.auto_awesome),

        SizedBox(height: verticalSpacing * 1.5),

        // Title
        Text(
          title,
          style: TextStyle(
            fontSize: context.screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : Colors.black,
          ),
        ),

        SizedBox(height: verticalSpacing * 0.5),

        // Subtitle
        Text(
          subtitle,
          style: TextStyle(
            fontSize: context.screenWidth * 0.035,
            color:
                isDark
                    ? AppColors.darkText.withValues(alpha: 0.7)
                    : Colors.black54,
          ),
        ),

        SizedBox(height: verticalSpacing * 2),
      ],
    );
  }
}
