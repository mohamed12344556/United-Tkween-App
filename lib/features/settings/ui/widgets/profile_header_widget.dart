import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import 'profile_avatar.dart';
// إضافة استيراد ملفات المتجاوبة

class ProfileHeaderWidget extends StatelessWidget {
  final String? profileImageUrl;
  final String fullName;
  final String email;

  const ProfileHeaderWidget({
    super.key,
    this.profileImageUrl,
    required this.fullName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد حجم الصورة الشخصية حسب نوع الجهاز والاتجاه
    double avatarRadius;
    
    if (context.isTablet) {
      avatarRadius = context.isLandscape ? 75.r : 85.r;
    } else if (context.isDesktop) {
      avatarRadius = 100.r;
    } else {
      // للهواتف
      avatarRadius = context.isLandscape ? 55.r : 60.r;
    }

    return Container(
      padding: EdgeInsets.only(
        top: 24.h, 
        bottom: 32.h
      ),
      decoration: const BoxDecoration(color: AppColors.darkBackground),
      child: Column(
        children: [
          ProfileAvatar(
            profileImageUrl: profileImageUrl,
            fullName: fullName,
            radius: avatarRadius,
            backgroundColor: AppColors.darkSecondary,
            textColor: AppColors.primary,
          ),
          SizedBox(height: 16.h),
          Text(
            fullName,
            style: TextStyle(
              fontSize: context.isTablet ? 28.sp : 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Text(
            email,
            style: TextStyle(
              fontSize: context.isTablet ? 16.sp : 14.sp, 
              color: Colors.grey[400]
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}