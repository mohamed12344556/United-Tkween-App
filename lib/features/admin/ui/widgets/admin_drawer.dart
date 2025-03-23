import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:united_formation_app/core/core.dart';

class AdminDrawer extends StatelessWidget {
  final String currentRoute;

  const AdminDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    log('AdminDrawer: currentRoute: $currentRoute');
    return Drawer(
      backgroundColor: AppColors.secondary,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'مدونة محمح التعليمية',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 32),
            _buildDrawerItem(
              context,
              icon: Icons.shopping_cart,
              title: 'الطلبات',
              route: Routes.adminOrdersView,
              isSelected: currentRoute == Routes.adminOrdersView,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.inventory_2,
              title: 'المنتجات',
              route: Routes.adminProductsView,
              isSelected: currentRoute == Routes.adminProductsView,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.add_circle,
              title: 'إضافة منتج',
              route: Routes.adminAddProductView,
              isSelected: currentRoute == Routes.adminAddProductView,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.support_agent,
              title: 'دعم العملاء',
              route: Routes.adminSupportView,
              isSelected: currentRoute == Routes.adminSupportView,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.home,
              title: 'المتجر الرئيسي',
              route: Routes.homeView,
              isSelected: currentRoute == Routes.homeView,
            ),
            const Spacer(),
            _buildDrawerItem(
              context,
              icon: Icons.logout,
              title: 'تسجيل الخروج',
              route: '',
              isSelected: false,
              isLoggedOut: true,
              onTap: () async {
                await context.showLogoutConfirmation();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
    VoidCallback? onTap,
    bool isLoggedOut = false,
  }) {
    return InkWell(
      onTap:
          onTap ??
          () {
            Navigator.pop(context); // Close drawer
            if (route.isNotEmpty) {
              Navigator.pushReplacementNamed(context, route);
            }
          },
      child: Container(
        color:
            isSelected
                ? AppColors.primary
                : isLoggedOut
                ? Colors.red
                : AppColors.lightGrey,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
