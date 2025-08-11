// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/core.dart';
// import '../cubits/profile/profile_cubit.dart';
// import '../cubits/profile/profile_state.dart';
// import '../widgets/profile_header_widget.dart';
// import '../widgets/contact_info_card_widget.dart';
// import '../widgets/address_card_widget.dart';
// import '../widgets/edit_profile_button_widget.dart';

// class ProfileView extends StatefulWidget {
//   const ProfileView({super.key});

//   @override
//   State<ProfileView> createState() => _ProfileViewState();
// }

// class _ProfileViewState extends State<ProfileView> {
//   @override
//   void initState() {
//     super.initState();
//     // تحميل البيانات مباشرة عند فتح الصفحة
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadProfileData();
//     });
//   }

//   // تحميل البيانات بشكل منفصل
//   void _loadProfileData() {
//     final cubit = context.read<ProfileCubit>();
//     if (!cubit.isClosed) {
//       cubit.loadProfile();
//     }
//   }

//   // تحديث البيانات عند السحب للأسفل
//   Future<void> _refreshProfile() async {
//     await context.read<ProfileCubit>().loadProfile();
//   }

//   // انتقال إلى صفحة التعديل مع استقبال النتيجة عند العودة
//   void _navigateToEditProfile() async {
//     // استخدام await للانتظار حتى العودة من الصفحة
//     final result = await Navigator.pushNamed(context, Routes.editProfileView);
//     // إذا كانت النتيجة true، قم بتحديث البيانات
//     if (result == true) {
//       // تأخير قصير لضمان تحميل البيانات بعد العودة مباشرة
//       Future.delayed(const Duration(milliseconds: 300), () {
//         context.showSuccessSnackBar(
//           'تم تحديث الملف الشخصي بنجاح بالرجاء الانتظار',
//         );
//         context.read<ProfileCubit>().loadProfile();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // تهيئة الأحجام المتجاوبة
//     context.initResponsive();

//     return Scaffold(
//       backgroundColor: AppColors.darkBackground,
//       appBar: _buildAppBar(),
//       body: RefreshIndicator(
//         onRefresh: _refreshProfile,
//         color: AppColors.primary,
//         backgroundColor: AppColors.darkSurface,
//         child: BlocConsumer<ProfileCubit, ProfileState>(
//           listener: (context, state) {
//             if (state.isProfileUpdated) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('تم تحديث الملف الشخصي بنجاح'),
//                   backgroundColor: AppColors.success,
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   margin: EdgeInsets.all(16.r),
//                 ),
//               );
//               context.read<ProfileCubit>().resetProfileUpdated();

//               // إعادة تحميل البيانات بعد التحديث
//               _loadProfileData();
//             }
//           },
//           builder: (context, state) {
//             if (state.isLoading && state.profile == null) {
//               return _buildLoadingState();
//             }

//             if (state.isError) {
//               return _buildErrorState();
//             }

//             // إذا كانت البيانات غير متوفرة، نعرض نموذج فارغ
//             if (state.profile == null) {
//               return _buildEmptyProfileUI();
//             }

//             return _buildProfileInfo(state);
//           },
//         ),
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: AppColors.darkBackground,
//       iconTheme: const IconThemeData(color: Colors.white),
//       scrolledUnderElevation: 0,
//       title: Text(
//         'الملف الشخصي',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           fontSize: 18.sp,
//         ),
//       ),
//       centerTitle: true,
//       elevation: 0,
//       toolbarHeight: 56.h,
//       actions: [
//         IconButton(
//           icon: Container(
//             padding: EdgeInsets.all(8.r),
//             decoration: BoxDecoration(
//               color: AppColors.darkSecondary,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(Icons.edit, color: AppColors.primary, size: 20.r),
//           ),
//           onPressed: _navigateToEditProfile,
//         ),
//         SizedBox(width: 8.w),
//       ],
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.r),
//         onPressed: () => Navigator.pop(context),
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     // يمكن استخدام Shimmer هنا لعرض حالة التحميل
//     return Center(
//       child: CircularProgressIndicator(
//         color: AppColors.primary,
//         backgroundColor: AppColors.secondary.withValues(alpha: 51),
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 60.r, color: AppColors.error),
//           SizedBox(height: 16.h),
//           Text(
//             'خطأ في تحميل الملف الشخصي',
//             style: TextStyle(color: Colors.white, fontSize: 16.sp),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 24.h),
//           SizedBox(
//             width: 200.w,
//             child: ElevatedButton.icon(
//               onPressed: _refreshProfile,
//               icon: Icon(Icons.refresh, size: 16.r),
//               label: Text('إعادة المحاولة', style: TextStyle(fontSize: 14.sp)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: AppColors.secondary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50.r),
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 12.h),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // نموذج فارغ للملف الشخصي
//   Widget _buildEmptyProfileUI() {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Column(
//         children: [
//           // رأس الملف الشخصي مع بيانات افتراضية
//           ProfileHeaderWidget(
//             // profileImageUrl: null,
//             fullName: "المستخدم",
//             email: "",
//           ),

//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Column(
//               children: [
//                 // بطاقة معلومات الاتصال فارغة
//                 ContactInfoCardWidget(email: "", phoneNumber1: ""),
//                 // بطاقة العنوان فارغة
//                 AddressCardWidget(address: ""),

//                 SizedBox(
//                   width: double.infinity,
//                   child: EditProfileButtonWidget(
//                     onPressed: _navigateToEditProfile,
//                   ),
//                 ),

//                 SizedBox(height: 24.h),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileInfo(ProfileState state) {
//     final profile = state.profile!;

//     if (context.isLandscape && context.isTablet) {
//       return _buildLandscapeLayout(profile);
//     }

//     return SingleChildScrollView(
//       physics: const AlwaysScrollableScrollPhysics(),
//       child: Column(
//         children: [
//           ProfileHeaderWidget(
//             // profileImageUrl: profile.profileImageUrl,
//             fullName: profile.fullName,
//             email: profile.email,
//           ),

//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Column(
//               children: [
//                 ContactInfoCardWidget(
//                   email: profile.email,
//                   phoneNumber1: profile.phoneNumber1,
//                 ),

//                 AddressCardWidget(address: profile.address),

//                 SizedBox(
//                   width: double.infinity,
//                   child: EditProfileButtonWidget(
//                     onPressed: _navigateToEditProfile,
//                   ),
//                 ),

//                 SizedBox(height: 24.h),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLandscapeLayout(profile) {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Padding(
//         padding: EdgeInsets.all(16.r),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 4,
//               child: ProfileHeaderWidget(
//                 // profileImageUrl: profile.profileImageUrl,
//                 fullName: profile.fullName,
//                 email: profile.email,
//               ),
//             ),

//             Expanded(
//               flex: 6,
//               child: Padding(
//                 padding: EdgeInsets.only(left: 16.w),
//                 child: Column(
//                   children: [
//                     ContactInfoCardWidget(
//                       email: profile.email,
//                       phoneNumber1: profile.phoneNumber1,
//                     ),

//                     AddressCardWidget(address: profile.address),

//                     EditProfileButtonWidget(onPressed: _navigateToEditProfile),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/auth/ui/widgets/guest_restriction_dialog.dart';
import '../../../../core/core.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/data/services/guest_mode_manager.dart';
import '../cubits/profile/profile_cubit.dart';
import '../cubits/profile/profile_state.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/contact_info_card_widget.dart';
import '../widgets/address_card_widget.dart';
import '../widgets/edit_profile_button_widget.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    // التحقق من وضع الضيف
    _checkGuestStatus();
    // تحميل البيانات مباشرة عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  Future<void> _checkGuestStatus() async {
    final isGuest = await GuestModeManager.isGuestMode();
    if (mounted) {
      setState(() {
        _isGuest = isGuest;
      });
    }
  }

  void _onItemTapped() async {
    // التحقق من القيود في وضع الضيف للصفحات المقيدة
    if (_isGuest) {
      // EditProfileView
      if (mounted) {
        await context.checkGuestRestriction(featureName: "تعديل الملف الشخصي");
      }
    }
  }

  // تحميل البيانات بشكل منفصل
  void _loadProfileData() {
    final cubit = context.read<ProfileCubit>();
    if (!cubit.isClosed) {
      cubit.loadProfile();
    }
  }

  // تحديث البيانات عند السحب للأسفل
  Future<void> _refreshProfile() async {
    await context.read<ProfileCubit>().loadProfile();
  }

  // انتقال إلى صفحة التعديل مع استقبال النتيجة عند العودة
  void _navigateToEditProfile() async {
    // استخدام await للانتظار حتى العودة من الصفحة

    final result = await Navigator.pushNamed(context, Routes.editProfileView);
    // إذا كانت النتيجة true، قم بتحديث البيانات
    if (result == true) {
      // تأخير قصير لضمان تحميل البيانات بعد العودة مباشرة
      Future.delayed(const Duration(milliseconds: 300), () {
        context.showSuccessSnackBar(
          S.of(context).profileUpdatedWait,
        );
        context.read<ProfileCubit>().loadProfile();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // تهيئة الأحجام المتجاوبة
    context.initResponsive();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: AppColors.primary,
        backgroundColor: Colors.white,
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.isProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).profileUpdated),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  margin: EdgeInsets.all(16.r),
                ),
              );
              context.read<ProfileCubit>().resetProfileUpdated();

              // إعادة تحميل البيانات بعد التحديث
              _loadProfileData();
            }
          },
          builder: (context, state) {
            if (state.isLoading && state.profile == null) {
              return _buildLoadingState();
            }

            if (state.isError) {
              return _buildErrorState();
            }

            // إذا كانت البيانات غير متوفرة، نعرض نموذج فارغ
            if (state.profile == null) {
              return _buildEmptyProfileUI();
            }

            return _buildProfileInfo(state);
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: AppColors.text),
      scrolledUnderElevation: 0,
      title: Text(
        S.of(context).profileTitle,
        style: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 56.h,
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit, color: AppColors.primary, size: 20.r),
          ),
          onPressed: _isGuest ? _onItemTapped : _navigateToEditProfile,
        ),
        SizedBox(width: 8.w),
      ],
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppColors.text, size: 20.r),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildLoadingState() {
    // يمكن استخدام Shimmer هنا لعرض حالة التحميل
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.secondary.withValues(alpha: 51),
        strokeWidth: context.isTablet ? 3.0 : 2.0,
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60.r, color: AppColors.error),
          SizedBox(height: 16.h),
          Text(
            S.of(context).profileLoadError,
            style: TextStyle(color: AppColors.text, fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: 200.w,
            child: ElevatedButton.icon(
              onPressed: _refreshProfile,
              icon: Icon(Icons.refresh, size: 16.r),
              label: Text(S.of(context).profileLoadError, style: TextStyle(fontSize: 14.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // نموذج فارغ للملف الشخصي
  Widget _buildEmptyProfileUI() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // رأس الملف الشخصي مع بيانات افتراضية
          ProfileHeaderWidget(
            // profileImageUrl: null,
            fullName: S.of(context).defaultUserName,
            email: "",
            textColor: AppColors.text,
            backgroundColor: AppColors.primary.withOpacity(0.1),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                // بطاقة معلومات الاتصال فارغة
                ContactInfoCardWidget(email: "", phoneNumber1: ""),
                // بطاقة العنوان فارغة
                AddressCardWidget(address: ""),

                SizedBox(
                  width: double.infinity,
                  child: EditProfileButtonWidget(
                    onPressed: _navigateToEditProfile,

                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(ProfileState state) {
    final profile = state.profile!;

    if (context.isLandscape && context.isTablet) {
      return _buildLandscapeLayout(profile);
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          ProfileHeaderWidget(
            // profileImageUrl: profile.profileImageUrl,
            fullName: profile.fullName,
            email: profile.email,
            textColor: AppColors.text,
            backgroundColor: AppColors.primary.withOpacity(0.1),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                ContactInfoCardWidget(
                  email: profile.email,
                  phoneNumber1: profile.phoneNumber1,
                ),

                // if (!Platform.isIOS)
                AddressCardWidget(address: profile.address),

                Opacity(
                  opacity: _isGuest ? 0.5 : 1.0,
                  child: SizedBox(
                    width: double.infinity,
                    child: EditProfileButtonWidget(
                      onPressed:
                          _isGuest ? _onItemTapped : _navigateToEditProfile,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(profile) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: ProfileHeaderWidget(
                // profileImageUrl: profile.profileImageUrl,
                fullName: profile.fullName,
                email: profile.email,
                textColor: AppColors.text,
                backgroundColor: AppColors.primary.withOpacity(0.1),
              ),
            ),

            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Column(
                  children: [
                    ContactInfoCardWidget(
                      email: profile.email,
                      phoneNumber1: profile.phoneNumber1,
                    ),

                    AddressCardWidget(address: profile.address),

                    EditProfileButtonWidget(
                      onPressed: _navigateToEditProfile,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
