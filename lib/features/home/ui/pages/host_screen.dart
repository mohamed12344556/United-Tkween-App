import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:united_formation_app/features/auth/data/services/guest_mode_manager.dart';
import 'package:united_formation_app/features/auth/ui/widgets/guest_restriction_dialog.dart';
import 'package:united_formation_app/features/favorites/presentation/views/favorites_view.dart';
import 'package:united_formation_app/features/settings/ui/views/settings_view.dart';
import '../../../../core/themes/app_colors.dart';
import 'home_page.dart';
import 'package:united_formation_app/features/cart/presentation/pages/cart_page.dart';

class HostPage extends StatefulWidget {
  const HostPage({super.key});

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  int _selectedIndex = 0;
  bool _isGuest = false;

  // الصفحات المتاحة
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [HomePage(), CartPage(), FavoritesView(), SettingsView()];
    _checkGuestStatus();
  }

  // التحقق من حالة الضيف وتعديل واجهة المستخدم بناءً عليها
  Future<void> _checkGuestStatus() async {
    final isGuest = await GuestModeManager.isGuestMode();
    if (mounted) {
      setState(() {
        _isGuest = isGuest;
      });
    }
  }

  void _onItemTapped(int index) async {
    // التحقق من القيود في وضع الضيف للصفحات المقيدة
    if (_isGuest) {
      if (index == 1) {
        // CartPage
        // عرض مربع حوار القيود عند محاولة الوصول إلى سلة التسوق
        if (mounted) {
          await context.checkGuestRestriction(featureName: "سلة التسوق");
        }
        return;
      } else if (index == 2) {
        // FavoritesView
        // عرض مربع حوار القيود عند محاولة الوصول إلى المفضلة
        if (mounted) {
          await context.checkGuestRestriction(featureName: "المفضلة");
        }
        return;
      }
    }

    // تغيير الصفحة المحددة إذا لم تكن مقيدة
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, 0),
                  _buildNavItem(Icons.shopping_bag_outlined, 1),
                  _buildNavItem(Icons.favorite_border, 2),
                  _buildNavItem(Icons.settings, 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    // تغيير لون الأيقونة للعناصر المقيدة في وضع الضيف
    Color iconColor;
    if (_isGuest && (index == 1 || index == 2)) {
      iconColor = isSelected ? Colors.grey : Colors.grey.shade700;
    } else {
      iconColor = isSelected ? Colors.black : Colors.grey.shade500;
    }

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(isSelected ? 10 : 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.primary : Colors.transparent,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: iconColor, size: 30),
            // عرض علامة القفل للعناصر المقيدة في وضع الضيف
            if (_isGuest && (index == 1 || index == 2))
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock, color: Colors.white, size: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
