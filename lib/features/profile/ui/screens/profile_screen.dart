import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/profile/ui/widgets/profile_menu_item.dart';
import 'package:united_formation_app/features/profile/ui/widgets/profile_social_icon.dart';
import '../../../../core/core.dart';
import '../cubits/profile/profile_cubit.dart';
import '../cubits/profile/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.isDarkMode ? AppColors.darkBackground : Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.secondary),
        title: const Text(
          'مجموعة تكوين المتحدة',
          style: TextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.isLoading && state.profile == null) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (state.isError && state.profile == null) {
              return _buildErrorWidget(context, state);
            }
            
            return Container(
              color: AppColors.primary,
              child: _buildMenuItems(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, ProfileState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.errorMessage ?? 'خطأ في تحميل الملف الشخصي',
            style: TextStyle(
              color: context.isDarkMode ? Colors.white : AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<ProfileCubit>().loadProfile(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.primary,
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
        // Menu items with improved animations
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              // Profile Menu Items
              _buildAnimatedMenuItem(
                index: 0,
                child: ProfileMenuItem(
                  title: 'الملف الشخصي',
                  icon: Icons.person,
                  onTap: () {
                    context.navigateToNamed(Routes.editProfileView);
                  },
                ),
              ),
              
              _buildAnimatedMenuItem(
                index: 1,
                child: ProfileMenuItem(
                  title: 'مشترياتي',
                  icon: Icons.shopping_cart,
                  onTap: () {
                    context.navigateToNamed(Routes.ordersView);
                  },
                ),
              ),
              
              _buildAnimatedMenuItem(
                index: 2,
                child: ProfileMenuItem(
                  title: 'مكتبتي',
                  icon: Icons.book,
                  onTap: () {
                    context.navigateToNamed(Routes.libraryView);
                  },
                ),
              ),
              
              _buildAnimatedMenuItem(
                index: 3,
                child: ProfileMenuItem(
                  title: 'دعم المتجر',
                  icon: Icons.headset_mic,
                  onTap: () {
                    context.navigateToNamed(Routes.supportView);
                  },
                ),
              ),
              
              _buildAnimatedMenuItem(
                index: 4,
                child: ProfileMenuItem(
                  title: 'المتجر الرئيسي',
                  icon: Icons.store,
                  onTap: () {
                    // التنقل إلى المتجر الرئيسي
                  },
                ),
              ),
              
              // Logout Button
              _buildAnimatedMenuItem(
                index: 5,
                child: ProfileMenuItem(
                  title: 'تسجيل الخروج',
                  icon: Icons.logout,
                  onTap: () {
                    _showLogoutConfirmation(context);
                  },
                  backgroundColor: AppColors.primary.withOpacity(0.5),
                  highlightColor: AppColors.error,
                  isHighlighted: true,
                ),
              ),
            ],
          ),
        ),

        // Social Media Icons
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileSocialIcon(
                icon: Icons.whatshot_outlined,
                onTap: () {
                  // TODO: تنفيذ الإجراء الخاص بمنصة التواصل الاجتماعي
                },
              ),
              ProfileSocialIcon(
                icon: Icons.facebook,
                onTap: () {
                  // TODO: تنفيذ الإجراء الخاص بفيسبوك
                },
              ),
              ProfileSocialIcon(
                icon: Icons.photo_camera,
                onTap: () {
                  // TODO: تنفيذ الإجراء الخاص بإنستجرام
                },
              ),
              ProfileSocialIcon(
                icon: Icons.chat_bubble,
                onTap: () {
                  // TODO: تنفيذ الإجراء الخاص بتويتر
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedMenuItem({required int index, required Widget child}) {
    // إضافة تأخير لتحميل كل عنصر بتسلسل للحصول على تأثير مرئي أفضل
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeInOut,
      child: AnimatedPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        duration: Duration(milliseconds: 300 + (index * 100)),
        curve: Curves.easeInOut,
        child: child,
      ),
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'تسجيل الخروج',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'هل أنت متأكد من تسجيل الخروج؟',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.text,
                    ),
                    child: const Text('إلغاء'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('تسجيل الخروج'),
                    onPressed: () {
                      // Implement logout functionality
                      Navigator.of(context).pop();
                      // TODO: تنفيذ منطق تسجيل الخروج
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}