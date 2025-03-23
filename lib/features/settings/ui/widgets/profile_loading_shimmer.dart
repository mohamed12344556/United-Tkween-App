// lib/features/settings/ui/widgets/profile_loading_shimmer.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/core.dart';

class ProfileLoadingShimmer extends StatelessWidget {
  const ProfileLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Shimmer.fromColors(
        baseColor: AppColors.darkSecondary,
        highlightColor: AppColors.darkSurface,
        child: Column(
          children: [
            // شيمر لصورة البروفايل
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60.r,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: 150.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 180.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),

            // شيمر لمعلومات الاتصال
            _buildShimmerCard(context),

            // شيمر لبطاقة العنوان
            _buildShimmerCard(context, isSmaller: true),

            // شيمر لزر التعديل
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              height: 56.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard(BuildContext context, {bool isSmaller = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.r),
      height: isSmaller ? 120.h : 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }
}