import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'core/routes/app_router.dart';
import 'core/api/dio_services.dart';
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