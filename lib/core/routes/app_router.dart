import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/settings/ui/cubits/library/library_cubit.dart';
import 'package:united_formation_app/features/settings/ui/cubits/orders/orders_cubit.dart';
import 'package:united_formation_app/features/settings/ui/views/library_view.dart';
import 'package:united_formation_app/features/settings/ui/views/orders_view.dart';
import 'package:united_formation_app/features/settings/ui/views/profile_view.dart';
import 'package:united_formation_app/features/settings/ui/views/settings_view.dart';
import 'routes.dart';
import '../utilities/enums/otp_purpose.dart';
import '../../features/auth/ui/cubits/learning_options/learning_options_cubit.dart';
import '../../features/auth/ui/cubits/login/login_cubit.dart';
import '../../features/auth/ui/cubits/otp/otp_cubit.dart';
import '../../features/auth/ui/cubits/password_reset/password_reset_cubit.dart';
import '../../features/auth/ui/cubits/register/register_cubit.dart';
import '../../features/auth/ui/pages/learning_options_page.dart';
import '../../features/auth/ui/pages/login_page.dart';
import '../../features/auth/ui/pages/otp_verification_page.dart';
import '../../features/auth/ui/pages/register_page.dart';
import '../../features/auth/ui/pages/request_otp_page.dart';
import '../../features/auth/ui/pages/reset_password_page.dart';
import '../../features/settings/ui/cubits/edit_profile/edit_profile_cubit.dart';
import '../../features/settings/ui/cubits/profile/profile_cubit.dart';
import '../../features/settings/ui/cubits/support/support_cubit.dart';
import '../../features/settings/ui/views/edit_profile_view.dart';
import '../../features/settings/ui/views/support_view.dart';
import 'package:get_it/get_it.dart';
import 'package:united_formation_app/features/home/ui/pages/admin_edit_product.dart';
import 'package:united_formation_app/features/home/ui/pages/product_details_page.dart';

import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/home/data/product_model.dart';
import '../../features/home/ui/pages/host_screen.dart';

final sl = GetIt.instance;

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.loginView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) {
                  final cubit = sl<LoginCubit>();

                  if (arguments is Map &&
                      arguments.containsKey('fresh_start')) {
                    cubit.resetState();
                  }

                  return cubit;
                },
                child: const LoginPage(),
              ),
        );

      case Routes.registerView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<RegisterCubit>(),
                child: const RegisterPage(),
              ),
        );

      case Routes.learningOptionsView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<LearningOptionsCubit>(),
                child: const LearningOptionsPage(),
              ),
        );

      case Routes.requestOtpView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) {
                  final cubit = sl<PasswordResetCubit>();
                  return cubit;
                },
                child: const RequestOtpPage(),
              ),
        );

      case Routes.verifyOtpView:
        String email;
        bool isFromRegister = false;
        if (arguments is String) {
          email = arguments;
          isFromRegister = true;
        } else if (arguments is Map) {
          email = arguments['email'] as String;
          isFromRegister = false;
        } else {
          email = "example@email.com";
          isFromRegister = true;
        }

        if (isFromRegister) {
          return MaterialPageRoute(
            settings: settings,
            builder:
                (_) => BlocProvider(
                  create:
                      (context) => OtpCubit(
                        email: email,
                        verifyOtpUseCase: sl(),
                        sendOtpUseCase: sl(),
                        purpose: OtpPurpose.accountVerification,
                      ),
                  child: OtpVerificationPage(email: email),
                ),
          );
        } else {
          return MaterialPageRoute(
            settings: settings,
            builder:
                (_) => BlocProvider(
                  create: (context) {
                    final cubit = sl<PasswordResetCubit>();
                    cubit.setEmail(email);
                    return cubit;
                  },
                  child: OtpVerificationPage(email: email),
                ),
          );
        }

      case Routes.resetPasswordView:
        Map<String, String> parsedArgs = {};
        if (arguments is Map) {
          parsedArgs = Map<String, String>.from(
            arguments.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ),
          );
        }
        String email = parsedArgs['email'] ?? "example@email.com";
        String otp = parsedArgs['otp'] ?? "0000";
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) {
                  final cubit = sl<PasswordResetCubit>();
                  cubit.setEmail(email);
                  cubit.setVerifiedOtp(otp);
                  return cubit;
                },
                child: ResetPasswordPage(email: email, otp: otp),
              ),
        );

      // Settings Routes
      case Routes.settingsView:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SettingsView(),
        );

      case Routes.profileView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<ProfileCubit>(),
                child: const ProfileView(),
              ),
        );

      case Routes.editProfileView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<EditProfileCubit>(),
                child: const EditProfileView(),
              ),
        );

      case Routes.ordersView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<OrdersCubit>(),
                child: const OrdersView(),
              ),
        );

      case Routes.libraryView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<LibraryCubit>(),
                child: const LibraryView(),
              ),
        );

      case Routes.supportView:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => BlocProvider(
                create: (context) => sl<SupportCubit>(),
                child: const SupportView(),
              ),
        );
      case Routes.homeView:
      case Routes.adminEditProductView:
        ProductModel product = arguments as ProductModel;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AdminEditProductPage(product: product),
        );

      case Routes.hostView:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HostPage(),
        );

      case Routes.productDetailsView:
        ProductModel product = arguments as ProductModel;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProductDetailsPage(product: product),
        );

      case Routes.cartView:
        ProductModel product = arguments as ProductModel;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CartPage(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
