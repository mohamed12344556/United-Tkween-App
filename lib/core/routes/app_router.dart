import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/forget_password_cubit/forget_password_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/login_cubit/login_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/otp_cubit/otp_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/views/forget_password_view.dart';
import 'package:united_formation_app/features/auth/login/ui/views/login_view.dart';
import 'package:united_formation_app/features/auth/login/ui/views/otp_view.dart';
import 'package:united_formation_app/features/auth/signup/ui/logic/learning_options_cubit.dart';
import 'package:united_formation_app/features/auth/signup/ui/logic/register_cubit.dart';
import 'package:united_formation_app/features/home/home_view.dart';

import '../../features/auth/signup/ui/views/learning_options_view.dart';
import '../../features/auth/signup/ui/views/register_view.dart';
import '../core.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.loginView:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => LoginCubit(),
                child: LoginView(),
              ),
        );

      case Routes.registerView:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => RegisterCubit(),
                child: const RegisterView(),
              ),
        );

      case Routes.learningOptionsView:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => LearningOptionsCubit(),
                child: const LearningOptionsView(),
              ),
        );

      case Routes.forgetPasswordView:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => ForgetPasswordCubit(),
                child: const ForgetPasswordView(),
              ),
        );

      case Routes.otpAuthenticateView:
        // Expect email as argument for OTP verification
        if (arguments is String) {
          return MaterialPageRoute(
            builder:
                (_) => BlocProvider(
                  create: (context) => OtpCubit(email: arguments),
                  child: OtpView(email: arguments),
                ),
          );
        }
        // If no email provided, navigate back to login
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => LoginCubit(),
                child: LoginView(),
              ),
        );

      case Routes.homeView:
        return MaterialPageRoute(builder: (_) => const HomeView());

      default:
        return MaterialPageRoute(
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
