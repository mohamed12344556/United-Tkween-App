import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/core.dart';

class ContactInfoCardWidget extends StatelessWidget {
  final String email;
  final String? phoneNumber1;
  final String? phoneNumber2;

  const ContactInfoCardWidget({
    super.key,
    required this.email,
    this.phoneNumber1,
    this.phoneNumber2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.darkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات الاتصال',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(color: Colors.grey[700], height: 24.h),

            // عنصر البريد الإلكتروني
            _buildContactItem(
              icon: Icons.email,
              title: 'البريد الإلكتروني',
              value: email,
              context: context,
            ),

            // عنصر رقم الهاتف 1
            if (phoneNumber1 != null && phoneNumber1!.isNotEmpty)
              _buildContactItem(
                icon: Icons.phone,
                title: 'رقم الهاتف 1',
                value: phoneNumber1!,
                context: context,
                canCopy: true,
                canCall: true,
              ),

            // عنصر رقم الهاتف 2
            if (phoneNumber2 != null && phoneNumber2!.isNotEmpty)
              _buildContactItem(
                icon: Icons.phone_android,
                title: 'رقم الهاتف 2',
                value: phoneNumber2!,
                context: context,
                canCopy: true,
                canCall: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required BuildContext context,
    bool canCopy = true,
    bool canCall = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: AppColors.darkBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ],
            ),
          ),
          if (canCopy)
            IconButton(
              icon: Icon(Icons.copy, color: AppColors.primary, size: 18.r),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value)).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم نسخ $title'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      margin: EdgeInsets.all(16.r),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                });
              },
              splashRadius: 20.r,
            ),
        ],
      ),
    );
  }
}
