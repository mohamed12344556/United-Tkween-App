import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'app_bloc_observer.dart';


/// Initializes the BLoC system for your application.

Future<void> initBloc({
  bool enableHydratedBloc = true,
  bool enableBlocObserver = true,
}) async {
  // Initialize storage for HydratedBloc if enabled
  if (enableHydratedBloc) {
    final storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory((await getTemporaryDirectory()).path),
    );
    HydratedBloc.storage = storage;
  }

  // Set the global BlocObserver if enabled
  if (enableBlocObserver) {
    Bloc.observer = AppBlocObserver(
      // Configure observer settings
      logOnCreate: true,
      logOnChange: true,
      logOnClose: true,
      logOnError: true,
      logOnEvent: true,
      logOnTransition: kDebugMode, // Only in debug mode to reduce verbosity
      includeStackTrace: kDebugMode,
    );
  }
}
