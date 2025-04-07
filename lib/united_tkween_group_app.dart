import 'package:device_preview/device_preview.dart';
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
import 'dart:async';

import 'dart:async'; // 🔧 Add this!

class UnitedFormationApp extends StatelessWidget {
  final AppRouter appRouter;

  const UnitedFormationApp({super.key, required this.appRouter});

  String getInitialRoute() {
    final isLoggedIn = Prefs.getData(key: StorageKeys.isLoggedIn);
    print("------------------------$isLoggedIn----------------------");

    if (isLoggedIn == true) {
      print("------------------------User is logged in----------------------");
      final token = Prefs.getData(key: StorageKeys.accessToken);
      DioFactory.setTokenIntoHeader(token);
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
              // useInheritedMediaQuery: true,
              // builder: DevicePreview.appBuilder,
              navigatorKey: NavigationService.navigatorKey,
              theme: AppTheme.dark,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              // locale: Locale('ar'),
              supportedLocales: S.delegate.supportedLocales,
              initialRoute: getInitialRoute(),
              onGenerateRoute: appRouter.generateRoute,
            ),
          );
        },
      ),
    );

    // return FutureBuilder<String>(
    //   future: getInitialRoute(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const MaterialApp(
    //         home: Scaffold(
    //           body: Center(child: CircularProgressIndicator()),
    //         ),
    //       );
    //     }
    //
    //     return BlocProvider(
    //       create: (context) => ThemeCubit(),
    //       child: BlocBuilder<ThemeCubit, ThemeMode>(
    //         builder: (context, state) {
    //           return ScreenUtilInit(
    //             designSize: const Size(430, 953),
    //             minTextAdapt: true,
    //             splitScreenMode: true,
    //             child: MaterialApp(
    //               navigatorKey: NavigationService.navigatorKey,
    //               theme: AppTheme.dark,
    //               debugShowCheckedModeBanner: false,
    //               localizationsDelegates: const [
    //                 S.delegate,
    //                 GlobalMaterialLocalizations.delegate,
    //                 GlobalWidgetsLocalizations.delegate,
    //                 GlobalCupertinoLocalizations.delegate,
    //               ],
    //               supportedLocales: S.delegate.supportedLocales,
    //               title: 'Flutter Demo',
    //               initialRoute: snapshot.data ?? Routes.loginView,
    //               onGenerateRoute: appRouter.generateRoute,
    //             ),
    //           );
    //         },
    //       ),
    //     );
    //   },
    // );
  }
}

// class UnitedFormationApp extends StatelessWidget {
//   final AppRouter appRouter;
//
//   const UnitedFormationApp({super.key, required this.appRouter});
//
//   Future<String> getInitialRoute() async {
//     final isLoggedIn = await SharedPrefHelper.getBool(StorageKeys.isLoggedIn);
//
//     if (isLoggedIn == true) {
//       print("---------------------------");
//       print("User is logged in");
//
//       final token = await SharedPrefHelper.getSecuredString(StorageKeys.accessToken);
//       print("Token: $token");
//
//       DioFactory.setTokenIntoHeader(token); // لو حبيت تعيد ضبط التوكن
//
//       return Routes.hostView;
//     } else {
//       print("User not logged in");
//       return Routes.loginView;
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ThemeCubit(),
//       child: BlocBuilder<ThemeCubit, ThemeMode>(
//         builder: (context, state) {
//           return ScreenUtilInit(
//             designSize: const Size(430, 953),
//             minTextAdapt: true,
//             splitScreenMode: true,
//             child: MaterialApp(
//               navigatorKey: NavigationService.navigatorKey,
//               // useInheritedMediaQuery: true,
//               // locale: DevicePreview.locale(context),
//               // builder: DevicePreview.appBuilder,
//               // themeMode: state,
//               // theme: AppTheme.light,
//               // darkTheme: AppTheme.dark,
//               theme: AppTheme.dark,
//               debugShowCheckedModeBanner: false,
//               localizationsDelegates: const [
//                 S.delegate,
//                 GlobalMaterialLocalizations.delegate,
//                 GlobalWidgetsLocalizations.delegate,
//                 GlobalCupertinoLocalizations.delegate,
//               ],
//               supportedLocales: S.delegate.supportedLocales,
//               title: 'Flutter Demo',
//               initialRoute: getInitialRoute(),
//               onGenerateRoute: appRouter.generateRoute,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
