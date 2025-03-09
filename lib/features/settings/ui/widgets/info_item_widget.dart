import 'package:flutter/material.dart';
import '../../../../core/core.dart';
// إضافة استيراد ملفات المتجاوبة

class InfoItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isMultiLine;
  final Color? iconColor;
  final Color? containerColor;
  // إضافة متغيرات للأحجام المتجاوبة
  final double? iconSize;
  final double? titleSize;
  final double? valueSize;
  final double? containerSize;

  const InfoItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.isMultiLine = false,
    this.iconColor,
    this.containerColor,
    this.iconSize,
    this.titleSize,
    this.valueSize,
    this.containerSize,
  });

  @override
  Widget build(BuildContext context) {
    // تعيين الأحجام الافتراضية إذا لم يتم تمريرها
    final finalIconSize = iconSize ?? 16.r;
    final finalTitleSize = titleSize ?? 12.sp;
    final finalValueSize = valueSize ?? 14.sp;
    final finalContainerSize = containerSize ?? 8.r;
    
    return Row(
      crossAxisAlignment:
          isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: finalContainerSize.paddingAll,
          decoration: BoxDecoration(
            color: containerColor ?? AppColors.darkSecondary,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon, 
            color: iconColor ?? Colors.white, 
            size: finalIconSize
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: finalTitleSize, color: Colors.grey[400]),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: finalValueSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}