import 'package:flutter/material.dart';

import '../core.dart';

class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;
  final bool showBackground;

  const AppLoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
    this.message,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color indicatorColor =
        color ?? (isDarkMode ? Colors.white : AppColors.secondary);

    final Widget loadingIndicator = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: indicatorColor,
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    if (showBackground) {
      return Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black54 : Colors.white70,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(24),
        child: loadingIndicator,
      );
    }

    return loadingIndicator;
  }
}