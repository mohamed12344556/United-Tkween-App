import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/forget_password_cubit/forget_password_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/login_cubit/login_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/otp_cubit/otp_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/views/login_view.dart';
import 'package:united_formation_app/features/auth/login/ui/views/request_otp_view.dart';
import 'package:united_formation_app/features/auth/login/ui/views/reset_password_view.dart';
import 'package:united_formation_app/features/auth/login/ui/views/verify_otp_view.dart';
import 'package:united_formation_app/features/auth/signup/ui/logic/learning_options_cubit.dart';
import 'package:united_formation_app/features/auth/signup/ui/logic/register_cubit.dart';
import 'package:united_formation_app/features/home/home_view.dart';

import '../../features/auth/signup/ui/views/learning_options_view.dart';
import '../../features/auth/signup/ui/views/register_view.dart';
import '../core.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    print("Route: ${settings.name}, Arguments Type: ${arguments?.runtimeType}, Arguments: $arguments");

    switch (settings.name) {
      case Routes.loginView:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => LoginCubit(),
            child: LoginView(),
          ),
        );

      case Routes.registerView:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => RegisterCubit(),
            child: const RegisterView(),
          ),
        );

      case Routes.learningOptionsView:
        return MaterialPageRoute(
          settings: settings, 
          builder: (_) => BlocProvider(
            create: (context) => LearningOptionsCubit(),
            child: const LearningOptionsView(),
          ),
        );

      case Routes.otpAuthenticateView:
        // هذا المسار سنبقيه للتوافقية مع الإصدارات السابقة فقط
        if (arguments is String) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => BlocProvider(
              create: (context) => OtpCubit(
                email: arguments,
                purpose: OtpPurpose.accountVerification,
              ),
              child: VerifyOtpView(
                email: arguments,
              ),
            ),
          );
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => LoginCubit(),
            child: LoginView(),
          ),
        );

      // المسارات الجديدة
      case Routes.requestOtpView:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => ForgetPasswordCubit(),
            child: const RequestOtpView(),
          ),
        );

      case Routes.verifyOtpView:
        print("verifyOtpView Arguments Type: ${arguments.runtimeType}");
        String email;
        bool isFromRegister = false;
        
        if (arguments is String) {
          // من التسجيل
          email = arguments;
          isFromRegister = true;
          print("From Register with email: $email");
        } else if (arguments is Map) {
          // من استعادة كلمة المرور
          email = arguments['email'] as String;
          isFromRegister = false;
          print("From ForgetPassword with email: $email");
        } else {
          // حالة غير متوقعة
          print("Unexpected arguments type: ${arguments.runtimeType}");
          email = "example@email.com"; // قيمة افتراضية
          isFromRegister = true;
        }
        
        if (isFromRegister) {
          // إذا كان قادمًا من تسجيل جديد، استخدم OtpCubit
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => BlocProvider(
              create: (context) => OtpCubit(
                email: email,
                purpose: OtpPurpose.accountVerification,
              ),
              child: VerifyOtpView(email: email),
            ),
          );
        } else {
          // إذا كان قادمًا من استعادة كلمة المرور، استخدم ForgetPasswordCubit
          print("Creating ForgetPasswordCubit for OTP verification with email: $email");
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => BlocProvider(
              create: (context) {
                final cubit = ForgetPasswordCubit();
                cubit.setEmail(email);
                return cubit;
              },
              child: VerifyOtpView(email: email),
            ),
          );
        }

      case Routes.resetPasswordView:
        print("resetPasswordView Arguments: $arguments, Type: ${arguments.runtimeType}");
        
        Map<String, String> parsedArgs = {};
        
        if (arguments is Map) {
          parsedArgs = Map<String, String>.from(arguments.map((key, value) => MapEntry(key.toString(), value.toString())));
        }
        
        String email = parsedArgs['email'] ?? "example@email.com";
        String otp = parsedArgs['otp'] ?? "0000";
        
        print("Creating ResetPasswordView with email: $email, otp: $otp");
        
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = ForgetPasswordCubit();
              cubit.setEmail(email);
              cubit.setVerifiedOtp(otp);
              return cubit;
            },
            child: ResetPasswordView(
              email: email,
              otp: otp,
            ),
          ),
        );

      case Routes.homeView:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeView(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}