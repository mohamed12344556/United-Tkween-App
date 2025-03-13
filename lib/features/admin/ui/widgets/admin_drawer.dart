import 'package:flutter/material.dart';
import 'package:united_formation_app/core/core.dart';

class AdminDrawer extends StatelessWidget {
  final String currentRoute;
  
  const AdminDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.red,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'مدونة تيونس التعليمية',
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
              route: Routes.ordersView,
              isSelected: currentRoute == Routes.ordersView,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.inventory_2,
              title: 'المنتجات',
              route: Routes.libraryView,
              isSelected: currentRoute == Routes.libraryView,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.add_circle,
              title: 'إضافة منتج',
              route: Routes.adminEditProductView,
              isSelected: currentRoute == Routes.adminEditProductView,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.support_agent,
              title: 'دعم العملاء',
              route: Routes.supportView,
              isSelected: currentRoute == Routes.supportView,
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
  }) {
    return InkWell(
      onTap: onTap ?? () {
        Navigator.pop(context); // Close drawer
        if (route.isNotEmpty) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        color: isSelected ? Colors.red.shade600 : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}