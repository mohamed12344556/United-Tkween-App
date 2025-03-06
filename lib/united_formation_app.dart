import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/api/auth_interceptor.dart';
import 'core/routes/app_router.dart';
import 'core/routes/routes.dart';
import 'core/themes/app_theme.dart';
import 'core/themes/cubit/theme_cubit.dart';

class UnitedFormationApp extends StatelessWidget {
  final AppRouter appRouter;
  // final bool hasValidSession;
  const UnitedFormationApp({
    super.key,
    required this.appRouter,
    // required this.hasValidSession,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(430, 953),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp(
              navigatorKey: NavigationService.navigatorKey,
              // useInheritedMediaQuery: true,
              // locale: DevicePreview.locale(context),
              // builder: DevicePreview.appBuilder,
              themeMode: state,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              initialRoute: Routes.profileView,
              onGenerateRoute: appRouter.generateRoute,
              // hasValidSession ? Routes.homeView : Routes.onboardingView,
            ),
          );
        },
      ),
    );
  }
}