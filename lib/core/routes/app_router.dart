import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/auth/login/ui/logic/cubit/login_cubit.dart';
import 'package:united_formation_app/features/auth/login/ui/views/login_view.dart';
import 'package:united_formation_app/features/auth/signup/ui/logic/learning_options_cubit.dart';
import 'package:united_formation_app/features/auth/signup/ui/logic/register_cubit.dart';

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

      default:
        return null;
    }
  }
}
