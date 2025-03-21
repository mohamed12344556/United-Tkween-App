import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:united_formation_app/constants.dart';
import 'core/api/dio_services.dart';
import 'core/core.dart';
import 'core/routes/app_router.dart';
import 'core/themes/cubit/theme_cubit.dart';
import 'generated/l10n.dart';

class UnitedFormationApp extends StatelessWidget {
  final AppRouter appRouter;

  const UnitedFormationApp({super.key, required this.appRouter});

  String getInitialRoute() {
    if (Prefs.getData(key: StorageKeys.isLoggedIn) == true) {
      print("---------------------------");
      print("User is logged in");
      print("${Prefs.getData(key: StorageKeys.accessToken)}");
      print("---------------------------");

      return Routes.hostView;
    } else {
      return Routes.loginView;
    }
  }

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
              // themeMode: state,
              // theme: AppTheme.light,
              // darkTheme: AppTheme.dark,
              theme: AppTheme.dark,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              title: 'Flutter Demo',
              initialRoute:getInitialRoute(),
              onGenerateRoute: appRouter.generateRoute,
            ),
          );
        },
      ),
    );
  }
}
