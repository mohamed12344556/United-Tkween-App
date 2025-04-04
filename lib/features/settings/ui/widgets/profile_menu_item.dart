// import 'package:flutter/material.dart';
// import '../../../../core/core.dart';

// class ProfileMenuItem extends StatefulWidget {
//   final String title;
//   final IconData icon;
//   final VoidCallback onTap;
//   final Color? backgroundColor;
//   final Color? highlightColor;
//   final Color? iconBackgroundColor;
//   final bool isHighlighted;
//   final Widget? trailing;

//   const ProfileMenuItem({
//     super.key,
//     required this.title,
//     required this.icon,
//     required this.onTap,
//     this.backgroundColor,
//     this.highlightColor = AppColors.primary,
//     this.iconBackgroundColor,
//     this.isHighlighted = false,
//     this.trailing,
//   });

//   @override
//   State<ProfileMenuItem> createState() => _ProfileMenuItemState();
// }

// class _ProfileMenuItemState extends State<ProfileMenuItem> {
//   bool _isPressed = false;

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
//     final itemColor = widget.isHighlighted 
//         ? widget.highlightColor 
//         : (isDarkMode ? Colors.white : AppColors.text);
    
//     final bgColor = widget.backgroundColor ?? 
//         (isDarkMode ? AppColors.darkSurface : Colors.white);
    
//     final iconBgColor = widget.iconBackgroundColor ?? 
//         (widget.isHighlighted 
//             ? widget.highlightColor?.withOpacity(0.2) 
//             : (isDarkMode ? AppColors.darkSecondary : Colors.grey[100]));
    
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 150),
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: _isPressed ? bgColor.withOpacity(0.8) : bgColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           if (!isDarkMode)
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: widget.onTap,
//           onHighlightChanged: (value) {
//             setState(() {
//               _isPressed = value;
//             });
//           },
//           borderRadius: BorderRadius.circular(16),
//           splashColor: widget.isHighlighted 
//               ? widget.highlightColor?.withOpacity(0.1) 
//               : AppColors.primary.withOpacity(0.1),
//           highlightColor: Colors.transparent,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: iconBgColor,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     widget.icon,
//                     color: widget.isHighlighted 
//                         ? widget.highlightColor 
//                         : AppColors.primary,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Text(
//                     widget.title,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: itemColor,
//                     ),
//                   ),
//                 ),
//                 widget.trailing ?? 
//                   Icon(
//                     Icons.navigate_next,
//                     size: 20,
//                     color: widget.isHighlighted
//                         ? widget.highlightColor?.withOpacity(0.7)
//                         : (isDarkMode ? Colors.white54 : Colors.grey[400]),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback onTap;
  final bool isHighlighted;
  final Color? highlightColor;
  final Widget? trailing;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.textColor,
    required this.onTap,
    this.isHighlighted = false,
    this.highlightColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final defaultIconColor = iconColor ?? AppColors.primary;
    final defaultBackgroundColor = backgroundColor ?? AppColors.lightGrey;
    final defaultTextColor = textColor ?? AppColors.text;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: defaultBackgroundColor,
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: (highlightColor ?? AppColors.primary).withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isHighlighted
                ? highlightColor ?? AppColors.primary
                : defaultIconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isHighlighted ? Colors.white : defaultIconColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: defaultTextColor,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        trailing: trailing ??
            Icon(
              Icons.arrow_forward_ios,
              color: defaultTextColor.withOpacity(0.5),
              size: 16,
            ),
      ),
    );
  }
}