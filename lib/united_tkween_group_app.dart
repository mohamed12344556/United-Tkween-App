import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:united_formation_app/core/utilities/app_version_manager.dart';
import 'core/api/dio_services.dart';
import 'core/core.dart';
import 'core/routes/app_router.dart';
import 'core/themes/cubit/theme_cubit.dart';
import 'generated/l10n.dart';
import 'dart:async';

class UnitedFormationApp extends StatefulWidget {
  final AppRouter appRouter;

  const UnitedFormationApp({super.key, required this.appRouter});

  @override
  State<UnitedFormationApp> createState() => _UnitedFormationAppState();
}

class _UnitedFormationAppState extends State<UnitedFormationApp> {
  bool _isUpdateAvailable = false;
  bool _isCheckingForUpdates = true;

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  // Check for app updates
  Future<void> _checkForUpdates() async {
    try {
      final needsUpdate = await AppVersionManager.isUpdateNeeded();
      setState(() {
        _isUpdateAvailable = needsUpdate;
        _isCheckingForUpdates = false;
      });
    } catch (e) {
      log('Error in update check: $e');
      setState(() {
        _isUpdateAvailable = false;
        _isCheckingForUpdates = false;
      });
    }
  }

  String getInitialRoute() {
    final isLoggedIn = Prefs.getData(key: StorageKeys.isLoggedIn);
    log("------------------------$isLoggedIn----------------------");

    if (isLoggedIn == true) {
      log("------------------------User is logged in----------------------");
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
              navigatorKey: NavigationService.navigatorKey,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: state,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: const Locale('ar'),
              supportedLocales: S.delegate.supportedLocales,
              initialRoute: getInitialRoute(),
              onGenerateRoute: widget.appRouter.generateRoute,
              builder: (context, child) {
                // Don't show any overlay while checking for updates

                if (_isCheckingForUpdates) {
                  return child ?? const SizedBox();
                }

                return Stack(
                  children: [
                    // Original content
                    child ?? const SizedBox(),

                    // Show update popup if needed
                    if (_isUpdateAvailable)
                      UpdateOverlay(
                        onUpdatePressed:
                            () => AppVersionManager.launchStore(context),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
