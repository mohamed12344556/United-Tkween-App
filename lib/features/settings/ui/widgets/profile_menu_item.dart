import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class ProfileMenuItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? highlightColor;
  final Color? iconBackgroundColor;
  final bool isHighlighted;
  final Widget? trailing;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.highlightColor = AppColors.primary,
    this.iconBackgroundColor,
    this.isHighlighted = false,
    this.trailing,
  });

  @override
  State<ProfileMenuItem> createState() => _ProfileMenuItemState();
}

class _ProfileMenuItemState extends State<ProfileMenuItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final itemColor = widget.isHighlighted 
        ? widget.highlightColor 
        : (isDarkMode ? Colors.white : AppColors.text);
    
    final bgColor = widget.backgroundColor ?? 
        (isDarkMode ? AppColors.darkSurface : Colors.white);
    
    final iconBgColor = widget.iconBackgroundColor ?? 
        (widget.isHighlighted 
            ? widget.highlightColor?.withOpacity(0.2) 
            : (isDarkMode ? AppColors.darkSecondary : Colors.grey[100]));
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _isPressed ? bgColor.withOpacity(0.8) : bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (value) {
            setState(() {
              _isPressed = value;
            });
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: widget.isHighlighted 
              ? widget.highlightColor?.withOpacity(0.1) 
              : AppColors.primary.withOpacity(0.1),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.isHighlighted 
                        ? widget.highlightColor 
                        : AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: itemColor,
                    ),
                  ),
                ),
                widget.trailing ?? 
                  Icon(
                    Icons.navigate_next,
                    size: 20,
                    color: widget.isHighlighted
                        ? widget.highlightColor?.withOpacity(0.7)
                        : (isDarkMode ? Colors.white54 : Colors.grey[400]),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}