import 'package:flutter/material.dart';
import '../../../../core/core.dart';
// إضافة استيراد ملفات المتجاوبة

class EditProfileButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  
  const EditProfileButtonWidget({
    super.key,
    required this.onPressed,
    this.buttonText = 'تعديل الملف الشخصي',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: SizedBox(
        width: double.infinity,
        height: context.isTablet ? 56.h : 48.h, // تغيير الارتفاع حسب نوع الجهاز
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            Icons.edit,
            size: context.isTablet ? 20.r : 16.r, // حجم الأيقونة متجاوب
          ),
          label: Text(
            buttonText,
            style: TextStyle(
              fontSize: context.isTablet ? 16.sp : 14.sp, // حجم الخط متجاوب
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.r), // نصف قطر حافة متجاوب
            ),
            padding: EdgeInsets.symmetric(vertical: 16.h), // تباعد متجاوب
            elevation: context.isTablet ? 3 : 2, // تظليل مختلف حسب نوع الجهاز
          ),
        ),
      ),
    );
  }
}