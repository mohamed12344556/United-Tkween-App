import 'package:flutter/material.dart';
import 'package:united_formation_app/constants.dart';
import 'package:united_formation_app/features/settings/ui/widgets/build_user_info_header.dart';
import 'package:united_formation_app/features/settings/ui/widgets/social_media_icons.dart';
import '../widgets/profile_menu_item.dart';
import '../../../../core/core.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkSurface,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: const Text(
          'مجموعة تكوين المتحدة',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.darkSecondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            onPressed: () {
            },
          ),
          const SizedBox(width: 8),
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SafeArea(child: Container(child: _buildMenuItems(context))),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BuildUserInfoHeader(context: context),
          if(Constants.isAdmin)
          Column(
            children: [
              Divider(color: AppColors.primary),
              _buildAnimatedMenuItem(
                index: 3,
                child: ProfileMenuItem(
                  title: "اداره النظام",
                  icon: Icons.settings,
                  onTap: () {
                    context.navigateToNamed(Routes.adminOrdersView);
                  },
                ),
              ),
              Divider(color: AppColors.primary),
            ],
          ),
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            children: [
              _buildSectionTitle('الحساب'),
          
              _buildAnimatedMenuItem(
                index: 0,
                child: ProfileMenuItem(
                  title: 'الملف الشخصي',
                  icon: Icons.person,
                  onTap: () {
                    context.navigateToNamed(Routes.profileView);
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
              Divider(color: AppColors.primary),
          
              const SizedBox(height: 16),
              _buildSectionTitle('الدعم'),
          
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
          
              const SizedBox(height: 8),
              Divider(color: AppColors.primary),
          
              // Logout Button
              _buildAnimatedMenuItem(
                index: 5,
                child: ProfileMenuItem(
                  title: 'تسجيل الخروج',
                  icon: Icons.logout,
                  onTap: () {
                    context.showLogoutConfirmation();
                  },
                  isHighlighted: true,
                  highlightColor: AppColors.error,
                ),
              ),
            ],
          ),
      
          // Social Media Icons
          SocialMediaIcons(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAnimatedMenuItem({required int index, required Widget child}) {
    final Animation<double> animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.1 * index.clamp(0, 9), // delay based on index
        1.0,
        curve: Curves.easeOutQuart,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animation.value)),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
      child: child,
    );
  }
}
