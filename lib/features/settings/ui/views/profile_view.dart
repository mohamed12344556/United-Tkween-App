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
  Widget build(BuildContext context) {
    // تهيئة الأحجام المتجاوبة
    context.initResponsive();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: _buildAppBar(),
      body: BlocConsumer<ProfileCubit, ProfileState>(
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
                margin: 16.marginAll,
              ),
            );
            context.read<ProfileCubit>().resetProfileUpdated();
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.profile == null) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.secondary.withValues(alpha: 51),
              ),
            );
          }

          if (state.isError && state.profile == null) {
            return _buildErrorState();
          }

          if (state.profile == null) {
            return _buildEmptyState();
          }

          return _buildProfileInfo(state);
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.darkBackground,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        'الملف الشخصي',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp, // حجم خط متجاوب
        ),
      ),
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 56.h, // ارتفاع متجاوب
      actions: [
        IconButton(
          icon: Container(
            padding: 8.paddingAll,
            decoration: BoxDecoration(
              color: AppColors.darkSecondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.edit,
              color: AppColors.primary,
              size: 20.r, // حجم متجاوب للأيقونة
            ),
          ),
          onPressed: () {
            context.navigateToNamed(Routes.editProfileView);
          },
        ),
        SizedBox(width: 8.w), // مسافة متجاوبة
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60.r, // حجم متجاوب للأيقونة
            color: AppColors.error,
          ),
          SizedBox(height: 16.h), // مسافة متجاوبة
          Text(
            'خطأ في تحميل الملف الشخصي',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp, // حجم خط متجاوب
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h), // مسافة متجاوبة
          SizedBox(
            width: context.isPhone ? 200.w : 180.w, // عرض متجاوب حسب نوع الجهاز
            child: ElevatedButton.icon(
              onPressed: () => context.read<ProfileCubit>().loadProfile(),
              icon: Icon(Icons.refresh, size: 16.r), // حجم متجاوب للأيقونة
              label: Text(
                'إعادة المحاولة',
                style: TextStyle(fontSize: 14.sp), // حجم خط متجاوب
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r), // حجم منحني متجاوب
                ),
                padding: 12.paddingVertical, // تباعد متجاوب
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'لم يتم العثور على بيانات الملف الشخصي',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp, // حجم خط متجاوب
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h), // مسافة متجاوبة
          SizedBox(
            width: context.isPhone ? 200.w : 180.w, // عرض متجاوب حسب نوع الجهاز
            child: ElevatedButton.icon(
              onPressed: () => context.read<ProfileCubit>().loadProfile(),
              icon: Icon(Icons.refresh, size: 16.r), // حجم متجاوب للأيقونة
              label: Text(
                'إعادة المحاولة',
                style: TextStyle(fontSize: 14.sp), // حجم خط متجاوب
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.r), // حجم منحني متجاوب
                ),
                padding: 12.paddingVertical, // تباعد متجاوب
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(ProfileState state) {
    final profile = state.profile!;

    // التحقق من اتجاه الشاشة لتغيير التخطيط في الوضع الأفقي
    if (context.isLandscape && !context.isPhone) {
      return _buildLandscapeLayout(profile);
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // استخدام المكونات المنفصلة مع إضافة التجاوبية
          ProfileHeaderWidget(
            profileImageUrl: profile.profileImageUrl,
            fullName: profile.fullName,
            email: profile.email,
          ),

          // تحسين المسافات لتكون متجاوبة
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  context.isTablet ? 24.w : 16.w, // هوامش متجاوبة حسب الجهاز
            ),
            child: Column(
              children: [
                ContactInfoCardWidget(
                  email: profile.email,
                  phoneNumber1: profile.phoneNumber1,
                  phoneNumber2: profile.phoneNumber2,
                ),

                AddressCardWidget(address: profile.address),

                SizedBox(
                  width:
                      context.isTablet
                          ? context.screenWidth * 0.6
                          : double.infinity,
                  child: EditProfileButtonWidget(
                    onPressed: () {
                      context.navigateToNamed(Routes.editProfileView);
                    },
                  ),
                ),

                SizedBox(height: 24.h), // مسافة متجاوبة
              ],
            ),
          ),
        ],
      ),
    );
  }

  // تخطيط مخصص للوضع الأفقي على الأجهزة الكبيرة
  Widget _buildLandscapeLayout(profile) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: 16.paddingAll,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // جانب للصورة والمعلومات الأساسية
            Expanded(
              flex: 4,
              child: ProfileHeaderWidget(
                profileImageUrl: profile.profileImageUrl,
                fullName: profile.fullName,
                email: profile.email,
              ),
            ),

            // جانب للمعلومات التفصيلية
            Expanded(
              flex: 6,
              child: Padding(
                padding: 16.paddingLeft,
                child: Column(
                  children: [
                    ContactInfoCardWidget(
                      email: profile.email,
                      phoneNumber1: profile.phoneNumber1,
                      phoneNumber2: profile.phoneNumber2,
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
