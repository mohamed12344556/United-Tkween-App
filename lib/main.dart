import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:united_formation_app/features/settings/data/datasources/hive_models/library_hive_model.dart';
import 'package:united_formation_app/features/settings/data/datasources/hive_models/order_hive_model.dart';
import 'package:united_formation_app/features/settings/data/datasources/hive_models/profile_hive_model.dart';
import 'core/routes/app_router.dart';
import 'core/api/dio_services.dart';
import 'features/auth/ui/pages/user_model.dart';
import 'features/home/data/book_model.dart';
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

  // ✅ Now it's safe to open the boxes
  await Hive.openBox<UserModel>('userBox');
  await Hive.openBox<BookModel>('favorites');
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


// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter/material.dart';
//
// // في الويدجت الخاص بك
// Widget buildCategoryItem(Map<String, dynamic> category) {
//   // تحويل سلسلة الأيقونة إلى IconData المناسب
//   IconData getIconData(String iconString) {
//     // إزالة "fas " من بداية السلسلة
//     String iconName = iconString.replaceAll('fas fa-', '');
//
//     // تحديد الأيقونة بناءً على الاسم
//     switch (iconName) {
//       case 'utensils':
//         return FontAwesomeIcons.utensils;
//     // أضف المزيد من الحالات للأيقونات الأخرى
//       default:
//         return FontAwesomeIcons.book; // أيقونة افتراضية
//     }
//   }
//
//   return Card(
//     child: ListTile(
//       leading: FaIcon(
//         getIconData(category['icon']),
//         color: Colors.orange,
//         size: 24,
//       ),
//       title: Text(
//         Localizations.localeOf(context).languageCode == 'ar'
//             ? category['name_ar']
//             : category['name_en'],
//       ),
//       onTap: () {
//         // التنقل إلى صفحة الفئة أو أي إجراء آخر
//       },
//     ),
//   );
// }