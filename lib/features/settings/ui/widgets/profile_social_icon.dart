import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class ProfileSocialIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? backgroundColor;

  const ProfileSocialIcon({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.backgroundColor,
  });

  @override
  State<ProfileSocialIcon> createState() => _ProfileSocialIconState();
}

class _ProfileSocialIconState extends State<ProfileSocialIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.color ?? AppColors.primary;
    final bgColor = widget.backgroundColor ?? Colors.black.withOpacity(0.3);
    
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: _isPressed ? [] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: iconColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Icon(
          widget.icon,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }
}