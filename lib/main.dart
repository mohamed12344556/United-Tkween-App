import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'generated/codegen_loader.g.dart';
import 'united_formation_app.dart';

import 'core/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupGetIt();
  // Initialize BLoC system
  await initBloc();
  // Initialize Hydrated Bloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
  // await AppState.initialize();
  // final bool hasValidSession = await TokenManager.hasValidTokens();
  // log('Main - AppState.isLoggedIn: ${AppState.isLoggedIn}');
  await ScreenUtil.ensureScreenSize();
  runApp(
    EasyLocalization(
      supportedLocales: Languages.all,
      path: 'assets/translations',
      assetLoader: CodegenLoader(),
      
      child: UnitedFormationApp(
        appRouter: AppRouter(),
        // hasValidSession: hasValidSession,
      ),
    ),
  );
}


// import 'package:device_preview/device_preview.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:path_provider/path_provider.dart';
// import 'generated/codegen_loader.g.dart';
// import 'united_formation_app.dart';

// import 'core/core.dart';


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await EasyLocalization.ensureInitialized();
//   await setupGetIt();
//   // Initialize BLoC system
//   await initBloc();
//   // Initialize Hydrated Bloc
//   HydratedBloc.storage = await HydratedStorage.build(
//     storageDirectory:
//         kIsWeb
//             ? HydratedStorageDirectory.web
//             : HydratedStorageDirectory((await getTemporaryDirectory()).path),
//   );
//   // await AppState.initialize();
//   // final bool hasValidSession = await TokenManager.hasValidTokens();
//   // log('Main - AppState.isLoggedIn: ${AppState.isLoggedIn}');
//   await ScreenUtil.ensureScreenSize();
//   runApp(
//     DevicePreview(
//       enabled: !kReleaseMode, // Enable only in debug mode
//       builder: (context) => EasyLocalization(
//         supportedLocales: Languages.all,
//         path: 'assets/translations',
//         assetLoader: CodegenLoader(),
//         child: UnitedFormationApp(
//           appRouter: AppRouter(),
//           // hasValidSession: hasValidSession,
//         ),
//       ),
//     ),
//   );
// }