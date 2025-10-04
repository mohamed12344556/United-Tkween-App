import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:united_formation_app/features/home/ui/pages/host_screen.dart';
import 'package:united_formation_app/features/auth/ui/pages/login_page.dart';
import '../../core/api/dio_factory.dart';
import '../../core/api/dio_services.dart';
import '../../core/app_links/app_links.dart';
import '../../core/app_links/deep_link_manager.dart';
import '../../core/utilities/storage_keys.dart';
import '../../core/widgets/connection_wrapper.dart';
import '../auth/ui/cubits/login/login_cubit.dart';
import '../home/ui/pages/product_details_page.dart';

final sl = GetIt.instance;

class SplashScreen extends StatefulWidget {
  final String? initialLink;

  const SplashScreen({super.key, this.initialLink});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 2500), () {
      _handleNavigation();
    });
  }

  void _handleNavigation() async {
    final isAlreadyLogin = Prefs.getData(key: StorageKeys.isLoggedIn);
    final userToken = Prefs.getData(key: StorageKeys.accessToken) as String?;
    DioFactory.setTokenIntoHeader(userToken ?? "");
    final isLoggedIn =
        isAlreadyLogin == true && userToken != null && userToken.isNotEmpty;

    print('User logged in: $isLoggedIn');

    // ✅ Deep Link Detected
    if (widget.initialLink != null) {
      final productId = AppLinksHandler.extractProductId(widget.initialLink!);

      if (productId != null) {
        print('Deep Link detected for product: $productId');

        if (isLoggedIn) {
          // ✅ User is logged in → go to home (HostPage)
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HostPage()),
            (route) => false,
          );

          // ✅ Open Product Details using the same pattern as AppRouter
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  // (_) => BlocProvider(
                  //   create:
                  //       (_) => sl<ProductCubit>()..fetchProductById(productId),
                  //   child: ProductDetailsPage(
                  //     book: BookModel(
                  //       id: productId,
                  //       title: 'Flutter Mastery Guide',
                  //       imageUrl:
                  //           'https://tkweenstore.com/images/flutter_book.jpg',
                  //       price: "299.0",
                  //       pdfPrice: "149.0",
                  //       bookType: 'Programming',
                  //       category: Category(
                  //         nameAr: "مصر ام الدنيا",
                  //         nameEn: "Egypt",
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  (_) => ProductDetailsPage(bookId: productId),
            ),
          );
        } else {
          DeepLinkManager.setPendingChallenge(productId);

          // ❌ Not logged in → go to Login using same AppRouter style
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider(
                    create: (context) {
                      final cubit = sl<LoginCubit>();
                      cubit.resetState(); // fresh start like in AppRouter
                      return cubit;
                    },
                    child: ConnectionWrapper(child: const LoginPage()),
                  ),
            ),
            (route) => false,
          );
        }
        return;
      }
    }

    // 🔄 Default Navigation (No Deep Link)
    Widget nextScreen;
    if (!isLoggedIn) {
      nextScreen = BlocProvider(
        create: (context) {
          final cubit = sl<LoginCubit>();
          cubit.resetState();
          return cubit;
        },
        child: ConnectionWrapper(child: const LoginPage()),
      );
    } else {
      nextScreen = const HostPage();
    }

    // ✅ Smooth transition
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Option 1: Use GIF animation (Recommended)
        // Uncomment when you add your splash GIF to assets
        // child: Image.asset(
        //   Assets.splashScreenGIF,
        //   fit: BoxFit.cover,
        //   width: double.infinity,
        //   height: double.infinity,
        // ),

        // Option 2: Use static image with text (Current)
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Books icon or your logo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_stories_rounded, // Book icon
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 30),

            // App name
            Text(
              'Tkween',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'مكتبتك الإلكترونية',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),

            // Loading indicator
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
