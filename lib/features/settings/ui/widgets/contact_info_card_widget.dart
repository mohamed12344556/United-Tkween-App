import 'package:flutter/material.dart';
import 'package:united_formation_app/core/widgets/app_card.dart';
import '../../../../core/core.dart';
import 'info_item_widget.dart';

class ContactInfoCardWidget extends StatelessWidget {
  final String email;
  final String? phoneNumber1;
  final String? phoneNumber2;

  const ContactInfoCardWidget({
    Key? key,
    required this.email,
    required this.phoneNumber1,
    this.phoneNumber2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.symmetric(
        // هوامش متجاوبة حسب حجم وتوجه الشاشة
        horizontal: context.isTablet 
            ? (context.isLandscape ? 8.w : 16.w) 
            : 16.w,
        vertical: 8.h,
      ),
      color: AppColors.darkSurface,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان البطاقة
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Row(
              children: [
                Container(
                  padding: 8.paddingAll,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 51),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.contact_mail,
                    color: AppColors.primary,
                    size: context.isTablet ? 22.r : 18.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'معلومات الاتصال',
                  style: TextStyle(
                    fontSize: context.isTablet ? 18.sp : 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          InfoItemWidget(
            icon: Icons.email,
            title: 'البريد الإلكتروني',
            value: email,
            iconSize: context.isTablet ? 20.r : 16.r,
            titleSize: context.isTablet ? 14.sp : 12.sp,
            valueSize: context.isTablet ? 16.sp : 14.sp,
          ),

          Divider(color: Colors.grey[800], height: 24.h),

          InfoItemWidget(
            icon: Icons.phone,
            title: 'رقم الهاتف الأساسي',
            value: phoneNumber1 ?? 'غير محدد',
            iconSize: context.isTablet ? 20.r : 16.r,
            titleSize: context.isTablet ? 14.sp : 12.sp,
            valueSize: context.isTablet ? 16.sp : 14.sp,
          ),

          if (phoneNumber2 != null && phoneNumber2!.isNotEmpty) ...[
            Divider(color: Colors.grey[800], height: 24.h),
            InfoItemWidget(
              icon: Icons.phone_android,
              title: 'رقم الهاتف الإضافي',
              value: phoneNumber2!,
              iconSize: context.isTablet ? 20.r : 16.r,
              titleSize: context.isTablet ? 14.sp : 12.sp,
              valueSize: context.isTablet ? 16.sp : 14.sp,
            ),
          ],
        ],
      ),
    );
  }
}