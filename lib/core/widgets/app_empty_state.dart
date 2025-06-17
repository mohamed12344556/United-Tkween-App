// import 'package:flutter/material.dart';

// import '../core.dart';

// /// مكون حالة فارغة موحد قابل لإعادة الاستخدام عبر التطبيق
// class AppEmptyState extends StatelessWidget {
//   final String title;
//   final String message;
//   final IconData icon;
//   final String? buttonText;
//   final VoidCallback? onButtonPressed;
//   final double? iconSize;
//   final Color? iconColor;

//   const AppEmptyState({
//     Key? key,
//     required this.title,
//     required this.message,
//     required this.icon,
//     this.buttonText,
//     this.onButtonPressed,
//     this.iconSize,
//     this.iconColor,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: iconSize ?? 80,
//             color: iconColor ??
//                 (isDarkMode ? Colors.white60 : Colors.grey[400]),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: isDarkMode ? Colors.white : AppColors.text,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 12),
//           Text(
//             message,
//             style: TextStyle(
//               fontSize: 16,
//               color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           if (buttonText != null && onButtonPressed != null) ...[
//             const SizedBox(height: 32),
//             AppButton(
//               text: buttonText!,
//               onPressed: onButtonPressed!,
//               isFullWidth: false,
//               icon: Icons.refresh,
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../core.dart';

/// مكون حالة فارغة موحد قابل لإعادة الاستخدام عبر التطبيق
class AppEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double? iconSize;
  final Color? iconColor;

  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.buttonText,
    this.onButtonPressed,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize ?? 80,
            color:
                iconColor ??
                (isDarkMode
                    ? Colors.white60
                    : AppColors.primary.withOpacity(0.3)),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (buttonText != null && onButtonPressed != null) ...[
            const SizedBox(height: 32),
            AppButton(
              text: buttonText!,
              onPressed: onButtonPressed!,
              isFullWidth: false,
              icon: Icons.refresh,
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
            ),
          ],
        ],
      ),
    );
  }
}
