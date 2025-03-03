import 'package:flutter/material.dart';
import 'package:united_formation_app/features/auth/login/ui/views/login_view.dart';

import '../../features/auth/signup/ui/views/learning_options_view.dart';
import '../../features/auth/signup/ui/views/register_view.dart';
import '../core.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.loginView:
        return MaterialPageRoute(builder: (_) => const LoginView());

      case Routes.registerView:
        return MaterialPageRoute(builder: (_) => const RegisterView());

      case Routes.learningOptionsView:
        return MaterialPageRoute(builder: (_) => const LearningOptionsView());

      default:
        return null;
    }
  }
}
