import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:united_formation_app/features/settings/data/datasources/hive_models/library_hive_model.dart';
import 'package:united_formation_app/features/settings/data/datasources/hive_models/order_hive_model.dart';
import 'package:united_formation_app/features/settings/data/datasources/hive_models/profile_hive_model.dart';

import 'core/api/dio_services.dart';
import 'core/core.dart';
import 'core/routes/app_router.dart';
import 'core/services/deep_link_service.dart';
import 'features/auth/ui/pages/user_model.dart';
import 'features/cart/data/models/cart_model.dart';
import 'features/home/data/book_model.dart';
import 'united_tkween_group_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive
  await Hive.initFlutter();

  // تسجيل محولات Hive مع التحقق
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(UserModelAdapter());
  }

  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(ProfileHiveModelAdapter());
  }

  await setupGetIt();
  if (!Hive.isAdapterRegistered(11)) {
    Hive.registerAdapter(OrderHiveModelAdapter());
  }

  if (!Hive.isAdapterRegistered(12)) {
    Hive.registerAdapter(LibraryHiveModelAdapter());
  }
  // Initialize BLoC system
  await initBloc();
  // Initialize Hydrated Bloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
  await Prefs.init();
  // ✅ Register Hive Adapters BEFORE opening any box
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(BookModelAdapter());
  }

  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(CategoryAdapter());
  }

  if (!Hive.isAdapterRegistered(112)) {
    Hive.registerAdapter(CartItemModelAdapter());
  }
  await Hive.openBox<CartItemModel>('CartBox');

  // ✅ Now it's safe to open the boxes
  await Hive.openBox<UserModel>('userBox');
  await Hive.openBox<BookModel>('favorites');
  await Hive.openBox<OrderHiveModel>('orders_box');
  // await AppState.initialize();
  // final bool hasValidSession = await TokenManager.hasValidTokens();
  // log('Main - AppState.isLoggedIn: ${AppState.isLoggedIn}');
  await ScreenUtil.ensureScreenSize();

  // Initialize Deep Link Service
  await DeepLinkService.initialize();

  runApp(
    UnitedFormationApp(
      appRouter: AppRouter(),
      // hasValidSession: hasValidSession,
    ),
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder:
    //       (context) => UnitedFormationApp(
    //         appRouter: AppRouter(),
    //         // hasValidSession: hasValidSession,
    //       ), // Wrap your app
    // ),
  );
}

// email: m7@gmail.com
// password: 123456789@mA