// // import 'package:flutter/material.dart';
// // import 'package:united_formation_app/core/widgets/app_card.dart';
// // import '../../../../core/core.dart';
// // import 'info_item_widget.dart';

// // class AddressCardWidget extends StatelessWidget {
// //   final String? address;

// //   const AddressCardWidget({
// //     super.key,
// //     required this.address,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return AppCard(
// //       margin: EdgeInsets.symmetric(
// //         // هوامش متجاوبة حسب حجم وتوجه الشاشة
// //         horizontal: context.isTablet
// //             ? (context.isLandscape ? 8.w : 16.w)
// //             : 16.w,
// //         vertical: 8.h,
// //       ),
// //       color: AppColors.darkSurface,
// //       elevation: 0,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // عنوان البطاقة
// //           Padding(
// //             padding: EdgeInsets.only(bottom: 16.h),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   padding: 8.paddingAll,
// //                   decoration: BoxDecoration(
// //                     color: AppColors.primary.withValues(alpha: 51),
// //                     borderRadius: BorderRadius.circular(8.r),
// //                   ),
// //                   child: Icon(
// //                     Icons.location_on,
// //                     color: AppColors.primary,
// //                     size: context.isTablet ? 22.r : 18.r,
// //                   ),
// //                 ),
// //                 SizedBox(width: 12.w),
// //                 Text(
// //                   'العنوان',
// //                   style: TextStyle(
// //                     fontSize: context.isTablet ? 18.sp : 16.sp,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),

// //           InfoItemWidget(
// //             icon: Icons.home,
// //             title: 'تفاصيل العنوان',
// //             value: address ?? 'غير محدد',
// //             isMultiLine: true,
// //             iconSize: context.isTablet ? 20.r : 16.r,
// //             titleSize: context.isTablet ? 14.sp : 12.sp,
// //             valueSize: context.isTablet ? 16.sp : 14.sp,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../../../../core/core.dart';

// class AddressCardWidget extends StatelessWidget {
//   final String? address;

//   const AddressCardWidget({super.key, this.address});

//   @override
//   Widget build(BuildContext context) {
//     // إذا كان العنوان فارغًا أو غير موجود، لا تعرض البطاقة
//     if (address == null || address!.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return Card(
//       color: AppColors.darkSurface,
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
//       margin: EdgeInsets.symmetric(vertical: 8.h),
//       child: Padding(
//         padding: EdgeInsets.all(16.r),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'العنوان',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.copy, color: AppColors.primary, size: 18.r),
//                   onPressed: () {
//                     Clipboard.setData(ClipboardData(text: address!)).then((_) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: const Text('تم نسخ العنوان'),
//                           backgroundColor: AppColors.success,
//                           behavior: SnackBarBehavior.floating,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                           margin: EdgeInsets.all(16.r),
//                           duration: const Duration(seconds: 1),
//                         ),
//                       );
//                     });
//                   },
//                   splashRadius: 20.r,
//                 ),
//               ],
//             ),
//             Divider(color: Colors.grey[700], height: 16.h),
//             Row(
//               children: [
//                 Container(
//                   width: 40.r,
//                   height: 40.r,
//                   decoration: BoxDecoration(
//                     color: AppColors.darkBackground,
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: Icon(
//                     Icons.location_on,
//                     color: AppColors.primary,
//                     size: 20.r,
//                   ),
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Text(
//                     address!,
//                     style: TextStyle(color: Colors.white, fontSize: 16.sp),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8.h),
//             // زر إضافي للانتقال إلى الخريطة إذا لزم الأمر
//             // TextButton.icon(
//             //   onPressed: () {
//             //     // يمكن استخدام خدمة الخرائط هنا
//             //     UrlHelper.launchMapUrl(address!);
//             //   },
//             //   icon: Icon(Icons.map, size: 18.r),
//             //   label: Text('عرض على الخريطة', style: TextStyle(fontSize: 14.sp)),
//             //   style: TextButton.styleFrom(
//             //     foregroundColor: AppColors.primary,
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/core.dart';

class AddressCardWidget extends StatelessWidget {
  final String? address;

  const AddressCardWidget({super.key, this.address});

  @override
  Widget build(BuildContext context) {
    // إذا كان العنوان فارغًا أو غير موجود، لا تعرض البطاقة
    if (address == null || address!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: AppColors.primary, width: 1.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'العنوان',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: AppColors.primary, size: 18.r),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: address!)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('تم نسخ العنوان'),
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
            Divider(color: Colors.grey[300], height: 16.h),
            Row(
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: 20.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    address == "Default Address" ? "Not Entered" : address!,
                    style: TextStyle(color: AppColors.text, fontSize: 16.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
