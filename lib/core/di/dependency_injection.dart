import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:united_formation_app/features/admin/data/repos/admin_repository_impl.dart';
import 'package:united_formation_app/features/admin/domain/repos/admin_repository.dart';
import 'package:united_formation_app/features/admin/ui/cubits/add_product/add_product_admin_cubit.dart';
import 'package:united_formation_app/features/admin/ui/cubits/edit_product/edit_product_admin_cubit.dart';
import 'package:united_formation_app/features/admin/ui/cubits/products/products_admin_cubit.dart';
import 'package:united_formation_app/features/admin/ui/cubits/support/support_admin_cubit.dart';
import 'package:united_formation_app/features/settings/domain/usecases/remove_profile_image_usecase.dart';
import 'package:united_formation_app/features/settings/domain/usecases/upload_profile_image_usecase.dart';
import 'package:united_formation_app/features/settings/ui/cubits/edit_profile/edit_profile_cubit.dart';
import 'package:united_formation_app/features/settings/ui/cubits/library/library_cubit.dart';
import 'package:united_formation_app/features/settings/ui/cubits/orders/orders_cubit.dart';
import 'package:united_formation_app/features/settings/ui/cubits/profile/profile_cubit.dart';
import '../../features/admin/ui/cubits/orders/orders_admin_cubit.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repos/auth_repository_impl.dart';
import '../../features/auth/domain/repos/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/ui/cubits/learning_options/learning_options_cubit.dart';
import '../../features/auth/ui/cubits/login/login_cubit.dart';
import '../../features/auth/ui/cubits/otp/otp_cubit.dart';
import '../../features/auth/ui/cubits/password_reset/password_reset_cubit.dart';
import '../../features/auth/ui/cubits/register/register_cubit.dart';
import '../../features/settings/data/datasources/profile_local_datasource.dart';
import '../../features/settings/data/datasources/profile_remote_datasource.dart';
import '../../features/settings/data/repos/profile_repository_impl.dart';
import '../../features/settings/domain/repos/profile_repository.dart';
import '../../features/settings/domain/usecases/contact_support_usecase.dart';
import '../../features/settings/domain/usecases/get_library_items_usecase.dart';
import '../../features/settings/domain/usecases/get_profile_usecase.dart';
import '../../features/settings/domain/usecases/get_user_orders_usecase.dart';
import '../../features/settings/domain/usecases/update_profile_usecase.dart';
import '../../features/settings/ui/cubits/support/support_cubit.dart';

import '../core.dart';

final sl = GetIt.instance;

Future<void> setupGetIt() async {
  //? Core
  final Dio dio = DioFactory.getDio();
  sl.registerLazySingleton<ApiService>(() => ApiService(dio));

  //? External
  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );

  //? Data Sources
  //! Authentication
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceMock(),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  //! Settings
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiService: sl()),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(),
  );

  //? Repositories
  //! Authentication
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  //! Settings
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      connectionChecker: sl(),
    ),
  );

  //! Admin
  sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl());

  //? Use Cases
  //! Authentication
  sl.registerLazySingleton(() => LoginUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SendOtpUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(authRepository: sl()));

  //! Settings
  sl.registerLazySingleton(() => GetProfileUseCase(profileRepository: sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(profileRepository: sl()));
  sl.registerLazySingleton(() => GetUserOrdersUseCase(profileRepository: sl()));
  sl.registerLazySingleton(
    () => GetLibraryItemsUseCase(profileRepository: sl()),
  );
  sl.registerLazySingleton(
    () => ContactSupportUseCase(profileRepository: sl()),
  );
  sl.registerLazySingleton(
    () => RemoveProfileImageUseCase(profileRepository: sl()),
  );
  sl.registerLazySingleton(
    () => UploadProfileImageUseCase(profileRepository: sl()),
  );

  //? Cubits
  //! Authentication
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerFactory(
    () => RegisterCubit(registerUseCase: sl(), sendOtpUseCase: sl()),
  );
  sl.registerFactory<OtpCubit>(
    () => OtpCubit(
      email: '', // Will be provided when creating instance
      verifyOtpUseCase: sl(),
      sendOtpUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => PasswordResetCubit(
      sendOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );
  sl.registerFactory(() => LearningOptionsCubit());

  //! Settings
  sl.registerFactory(() => ProfileCubit(getProfileUseCase: sl()));

  sl.registerFactory(
    () => EditProfileCubit(
      updateProfileUseCase: sl(),
      getProfileUseCase: sl(),
      removeProfileImageUseCase: sl(),
      uploadProfileImageUseCase: sl(),
    ),
  );

  sl.registerFactory(() => OrdersCubit(getUserOrdersUseCase: sl()));

  sl.registerFactory(() => LibraryCubit(getLibraryItemsUseCase: sl()));

  sl.registerFactory(() => SupportCubit(contactSupportUseCase: sl()));

  //! Admin
  sl.registerFactory(() => OrdersAdminCubit(repository: sl()));

  sl.registerFactory(() => ProductsAdminCubit(repository: sl()));

  sl.registerFactory(() => SupportAdminCubit(repository: sl()));

  sl.registerFactory(() => AddProductAdminCubit(repository: sl()));

  sl.registerFactory(() => EditProductAdminCubit(repository: sl()));
}

///! 1. `registerSingleton`
/// - Creates the object immediately during registration (Eager Initialization).
/// - Only one instance is created and shared across the entire application.
/// - Use Case: When you need the object to be available as soon as the app starts.
/// - Example: AppConfig, SessionManager.

///! 2. `registerLazySingleton`
/// - Creates the object only when it is first requested (Lazy Initialization).
/// - Only one instance is created and shared across the entire application.
/// - Use Case: To optimize performance by delaying object creation until needed.
/// - Example: DatabaseService, ApiClient.

///! 3. `registerFactory`
/// - Creates a new object instance every time it is requested.
/// - Use Case: When you need a new instance for every operation or request.
/// - Example: FormValidator, HttpRequest.

/// Comparison Table:
/// | Property            | `registerSingleton`  | `registerLazySingleton` | `registerFactory`       |
/// |---------------------|-----------------------|-------------------------|-------------------------|
/// | Creation Time       | Immediately          | On first request        | On every request        |
/// | Number of Instances | One                  | One                     | New instance every time |
/// | State Sharing       | Supported            | Supported               | Not supported           |
/// | Common Use Cases    | Settings, Sessions   | Heavy Services          | Temporary Objects       |
