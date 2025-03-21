// import 'package:flutter/material.dart';
// import '../../../../core/core.dart';
// import 'profile_avatar.dart';
// // إضافة استيراد ملفات المتجاوبة

// class ProfileHeaderWidget extends StatelessWidget {
//   final String? profileImageUrl;
//   final String fullName;
//   final String email;

//   const ProfileHeaderWidget({
//     super.key,
//     this.profileImageUrl,
//     required this.fullName,
//     required this.email,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // تحديد حجم الصورة الشخصية حسب نوع الجهاز والاتجاه
//     double avatarRadius;
    
//     if (context.isTablet) {
//       avatarRadius = context.isLandscape ? 75.r : 85.r;
//     } else if (context.isDesktop) {
//       avatarRadius = 100.r;
//     } else {
//       // للهواتف
//       avatarRadius = context.isLandscape ? 55.r : 60.r;
//     }

//     return Container(
//       padding: EdgeInsets.only(
//         top: 24.h, 
//         bottom: 32.h
//       ),
//       decoration: const BoxDecoration(color: AppColors.darkBackground),
//       child: Column(
//         children: [
//           ProfileAvatar(
//             profileImageUrl: profileImageUrl,
//             fullName: fullName,
//             radius: avatarRadius,
//             backgroundColor: AppColors.darkSecondary,
//             textColor: AppColors.primary,
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             fullName,
//             style: TextStyle(
//               fontSize: context.isTablet ? 28.sp : 24.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 6.h),
//           Text(
//             email,
//             style: TextStyle(
//               fontSize: context.isTablet ? 16.sp : 14.sp, 
//               color: Colors.grey[400]
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }


// lib/features/settings/ui/widgets/profile_header_widget.dart

import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import 'profile_avatar.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String fullName;
  final String email;
  final bool showEmailVerified;

  const ProfileHeaderWidget({
    super.key,
    required this.fullName,
    required this.email,
    this.showEmailVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      child: Column(
        children: [
          ProfileAvatar(
            fullName: fullName,
            radius: 60.r,
            backgroundColor: AppColors.darkSecondary,
            textColor: AppColors.primary,
          ),
          SizedBox(height: 16.h),
          Text(
            fullName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                email,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16.sp,
                ),
              ),
              if (showEmailVerified && email.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Icon(
                    Icons.verified,
                    color: AppColors.primary,
                    size: 16.r,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}