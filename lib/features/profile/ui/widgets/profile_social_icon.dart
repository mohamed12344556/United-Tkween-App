import 'package:flutter/material.dart';
import '../../../../core/core.dart';

/// مكون أيقونة التواصل الاجتماعي في صفحة الملف الشخصي
class ProfileSocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ProfileSocialIcon({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon, 
              color: AppColors.secondary, 
              size: 24
            ),
          ),
        ),
      ),
    );
  }
}