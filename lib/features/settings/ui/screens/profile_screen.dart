import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../cubits/profile/profile_cubit.dart';
import '../cubits/profile/profile_state.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/contact_info_card_widget.dart';
import '../widgets/address_card_widget.dart';
import '../widgets/edit_profile_button_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'خطأ في تحميل الملف الشخصي',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () => context.read<ProfileCubit>().loadProfile(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state.profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لم يتم العثور على بيانات الملف الشخصي',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () => context.read<ProfileCubit>().loadProfile(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            );
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
      title: const Text(
        'الملف الشخصي',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.darkSecondary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, color: AppColors.primary, size: 20),
          ),
          onPressed: () {
            context.navigateToNamed(Routes.editProfileView);
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildProfileInfo(ProfileState state) {
    final profile = state.profile!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // استخدام المكونات المنفصلة
          ProfileHeaderWidget(
            profileImageUrl: profile.profileImageUrl,
            fullName: profile.fullName,
            email: profile.email,
          ),
          
          ContactInfoCardWidget(
            email: profile.email,
            phoneNumber1: profile.phoneNumber1,
            phoneNumber2: profile.phoneNumber2,
          ),
          
          AddressCardWidget(
            address: profile.address,
          ),
          
          EditProfileButtonWidget(
            onPressed: () {
              context.navigateToNamed(Routes.editProfileView);
            },
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}