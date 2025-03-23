import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
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
  @override
  void initState() {
    super.initState();
    // تحميل البيانات مباشرة عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().loadProfile();
    });
  }

  // تحديث البيانات عند السحب للأسفل
  Future<void> _refreshProfile() async {
    await context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    // تهيئة الأحجام المتجاوبة
    context.initResponsive();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: AppColors.primary,
        backgroundColor: AppColors.darkSurface,
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.isProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم تحديث الملف الشخصي بنجاح'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  margin: EdgeInsets.all(16.r),
                ),
              );
              context.read<ProfileCubit>().resetProfileUpdated();

              // إضافة هذا السطر لإعادة تحميل البيانات
              context.read<ProfileCubit>().loadProfile();
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
      backgroundColor: AppColors.darkBackground,
      iconTheme: const IconThemeData(color: Colors.white),
      scrolledUnderElevation: 0,
      title: Text(
        'الملف الشخصي',
        style: TextStyle(
          color: Colors.white,
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
              color: AppColors.darkSecondary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit, color: AppColors.primary, size: 20.r),
          ),
          onPressed: () {
            Navigator.pushNamed(context, Routes.editProfileView).then((_) {
              final cubit = context.read<ProfileCubit>();
              if (!cubit.isClosed) {
                cubit.loadProfile();
              }
            });
          },
        ),

        SizedBox(width: 8.w),
      ],
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.r),
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
            'خطأ في تحميل الملف الشخصي',
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: 200.w,
            child: ElevatedButton.icon(
              onPressed: _refreshProfile,
              icon: Icon(Icons.refresh, size: 16.r),
              label: Text('إعادة المحاولة', style: TextStyle(fontSize: 14.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.secondary,
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
            fullName: "المستخدم",
            email: "",
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
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.editProfileView).then(
                        (_) {
                          final cubit = context.read<ProfileCubit>();
                          if (!cubit.isClosed) {
                            cubit.loadProfile();
                          }
                        },
                      );
                    },
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
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ProfileHeaderWidget(
            // profileImageUrl: profile.profileImageUrl,
            fullName: profile.fullName,
            email: profile.email,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                ContactInfoCardWidget(
                  email: profile.email,
                  phoneNumber1: profile.phoneNumber1,
                ),

                AddressCardWidget(address: profile.address),

                SizedBox(
                  width: double.infinity,
                  child: EditProfileButtonWidget(
                    onPressed: () {
                      context.navigateToNamed(Routes.editProfileView);
                    },
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
                      onPressed: () {
                        context.navigateToNamed(Routes.editProfileView);
                      },
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
