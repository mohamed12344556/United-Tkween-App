import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final profileCubit = context.watch<ProfileCubit>();
    final state = profileCubit.state;

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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage ?? 'خطأ في تحميل الملف الشخصي',
                      style: TextStyle(
                        color:
                            context.isDarkMode ? Colors.white : AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => profileCubit.loadProfile(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            return Container(
              color: AppColors.primary,
              child: Column(
                spacing: 10,
                children: [
                  // Profile Menu Items
                  _buildMenuItem(
                    icon: Icons.person,
                    title: 'الملف الشخصي',
                    onTap: () {
                      context.navigateToNamed(Routes.editProfileView);
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.shopping_cart,
                    title: 'مشترياتي',
                    count: 3,
                    onTap: () {
                      context.navigateToNamed(Routes.ordersView);
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.book,
                    title: 'مكتبتي',
                    onTap: () {
                      context.navigateToNamed(Routes.libraryView);
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.headset_mic,
                    title: 'دعم المتجر',
                    onTap: () {
                      context.navigateToNamed(Routes.supportView);
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.store,
                    title: 'المتجر الرئيسي',
                    onTap: () {
                      // التنقل إلى المتجر الرئيسي
                    },
                  ),

                  // Logout Button
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'تسجيل الخروج',
                    onTap: () {
                      _showLogoutConfirmation(context);
                    },
                    backgroundColor: AppColors.primary.withValues(alpha: 0.5),
                    highlightColor: AppColors.error,
                  ),
                  const Spacer(),

                  // Social Media Icons
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon(
                          Icons.whatshot_outlined,
                          onTap: () {},
                        ), //todo: add social media icons
                        _buildSocialIcon(Icons.facebook, onTap: () {}),
                        _buildSocialIcon(Icons.photo_camera, onTap: () {}),
                        _buildSocialIcon(Icons.chat_bubble, onTap: () {}),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    int? count,
    bool isHighlighted = false,
    Color backgroundColor = Colors.transparent,
    Color highlightColor = AppColors.primary,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color:
            isHighlighted
                ? AppColors.secondary.withValues(alpha: 0.2)
                : backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isHighlighted ? AppColors.secondary : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color:
                        isHighlighted ? AppColors.primary : AppColors.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                if (count != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, {required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Icon(icon, color: AppColors.secondary, size: 24),
      ),
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('تسجيل الخروج'),
              onPressed: () {
                // Implement logout functionality
                Navigator.of(context).pop();
                // Add logout logic here
              },
            ),
          ],
        );
      },
    );
  }
}
