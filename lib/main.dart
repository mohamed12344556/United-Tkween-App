import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'core/routes/app_router.dart';
import 'features/auth/ui/pages/api_ser.dart';
import 'features/auth/ui/pages/user_model.dart';
import 'united_tkween_group_app.dart';

import 'core/core.dart';

/// Main entry point of the application.
///
/// This function ensures all necessary initializations are performed before
/// the app starts. It sets up dependency injection, initializes the BLoC system
/// and Hydrated Bloc storage, and prepares Hive for local data storage. Finally,
/// it ensures screen size is set up and runs the UnitedFormationApp widget.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  // Initialize BLoC system 
  await initBloc();
  // Initialize Hydrated Bloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
  await Prefs.init();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('userBox');
  // await AppState.initialize();
  // final bool hasValidSession = await TokenManager.hasValidTokens();
  // log('Main - AppState.isLoggedIn: ${AppState.isLoggedIn}');
  await ScreenUtil.ensureScreenSize();
  runApp(
    UnitedFormationApp(
      appRouter: AppRouter(),
      // hasValidSession: hasValidSession,
    ),
  );
}
