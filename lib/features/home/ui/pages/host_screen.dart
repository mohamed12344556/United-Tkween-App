// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:united_formation_app/features/auth/data/services/guest_mode_manager.dart';
// import 'package:united_formation_app/features/auth/ui/widgets/guest_restriction_dialog.dart';
// import 'package:united_formation_app/features/favorites/presentation/views/favorites_view.dart';
// import 'package:united_formation_app/features/settings/ui/views/settings_view.dart';
// import '../../../../core/themes/app_colors.dart';
// import 'home_page.dart';
// import 'package:united_formation_app/features/cart/presentation/pages/cart_page.dart';

// class HostPageContent extends StatefulWidget {
//   const HostPageContent({super.key});

//   @override
//   State<HostPageContent> createState() => _HostPageContentState();
// }

// class _HostPageContentState extends State<HostPageContent> {
//   int _selectedIndex = 0;
//   bool _isGuest = false;

//   // الصفحات المتاحة
//   late final List<Widget> _pages;

//   @override
//   void initState() {
//     super.initState();
//     _pages = [HomePage(), CartPage(), FavoritesView(), SettingsView()];
//     _checkGuestStatus();
//   }

//   // التحقق من حالة الضيف وتعديل واجهة المستخدم بناءً عليها
//   Future<void> _checkGuestStatus() async {
//     final isGuest = await GuestModeManager.isGuestMode();
//     if (mounted) {
//       setState(() {
//         _isGuest = isGuest;
//       });
//     }
//   }

//   void _onItemTapped(int index) async {
//     // التحقق من القيود في وضع الضيف للصفحات المقيدة
//     if (_isGuest) {
//       if (index == 1) {
//         // CartPage
//         // عرض مربع حوار القيود عند محاولة الوصول إلى سلة التسوق
//         if (mounted) {
//           await context.checkGuestRestriction(featureName: "سلة التسوق");
//         }
//         return;
//       } else if (index == 2) {
//         // FavoritesView
//         // عرض مربع حوار القيود عند محاولة الوصول إلى المفضلة
//         if (mounted) {
//           await context.checkGuestRestriction(featureName: "المفضلة");
//         }
//         return;
//       }
//     }

//     // تغيير الصفحة المحددة إذا لم تكن مقيدة
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(30),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.black.withValues(alpha: 0.5),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildNavItem(Icons.home, 0),
//                   if (!Platform.isIOS)
//                     _buildNavItem(Icons.shopping_bag_outlined, 1),
//                   _buildNavItem(Icons.favorite_border, 2),
//                   _buildNavItem(Icons.settings, 3),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, int index) {
//     bool isSelected = _selectedIndex == index;
//     // تغيير لون الأيقونة للعناصر المقيدة في وضع الضيف
//     Color iconColor;
//     if (_isGuest && (index == 1 || index == 2)) {
//       iconColor = isSelected ? Colors.grey : Colors.grey.shade700;
//     } else {
//       iconColor = isSelected ? Colors.black : Colors.grey.shade500;
//     }

//     return GestureDetector(
//       onTap: () => _onItemTapped(index),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: EdgeInsets.all(isSelected ? 10 : 5),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: isSelected ? AppColors.primary : Colors.transparent,
//         ),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Icon(icon, color: iconColor, size: 30),
//             // عرض علامة القفل للعناصر المقيدة في وضع الضيف
//             if (_isGuest && (index == 1 || index == 2))
//               Positioned(
//                 right: 0,
//                 bottom: 0,
//                 child: Container(
//                   padding: const EdgeInsets.all(2),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.7),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.lock, color: Colors.white, size: 10),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/auth/data/services/guest_mode_manager.dart';
import 'package:united_formation_app/features/auth/ui/widgets/guest_restriction_dialog.dart';
import 'package:united_formation_app/features/favorites/presentation/views/favorites_view.dart';
import 'package:united_formation_app/features/settings/ui/views/settings_view.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../cubit/home_cubit.dart';
import 'home_page.dart';
import 'package:united_formation_app/features/cart/presentation/pages/cart_page.dart';

class HostPage extends StatelessWidget {
  const HostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<HomeCubit>()..getHomeBooks(),
      child: HostPageContent(),
    );
  }
}

class HostPageContent extends StatefulWidget {
  const HostPageContent({super.key});

  @override
  State<HostPageContent> createState() => _HostPageContentState();
}

class _HostPageContentState extends State<HostPageContent> {
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
      backgroundColor: AppColors.background,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, 0),
                  // if (!Platform.isIOS)
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
      iconColor = isSelected ? Colors.grey : Colors.grey.shade400;
    } else {
      iconColor = isSelected ? Colors.white : Colors.grey.shade600;
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
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Icon(Icons.lock, color: Colors.grey, size: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
