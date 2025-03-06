import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:united_formation_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:united_formation_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:united_formation_app/features/auth/data/repos/auth_repository_impl.dart';
import 'package:united_formation_app/features/auth/domain/repos/auth_repository.dart';
import 'package:united_formation_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:united_formation_app/features/auth/ui/cubits/learning_options/learning_options_cubit.dart';
import 'package:united_formation_app/features/auth/ui/cubits/login/login_cubit.dart';
import 'package:united_formation_app/features/auth/ui/cubits/otp/otp_cubit.dart';
import 'package:united_formation_app/features/auth/ui/cubits/password_reset/password_reset_cubit.dart';
import 'package:united_formation_app/features/auth/ui/cubits/register/register_cubit.dart';
import 'package:united_formation_app/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:united_formation_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:united_formation_app/features/profile/data/repos/profile_repository_impl.dart';
import 'package:united_formation_app/features/profile/domain/repos/profile_repository.dart';
import 'package:united_formation_app/features/profile/domain/usecases/contact_support_usecase.dart';
import 'package:united_formation_app/features/profile/domain/usecases/get_library_items_usecase.dart';
import 'package:united_formation_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:united_formation_app/features/profile/domain/usecases/get_user_orders_usecase.dart';
import 'package:united_formation_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:united_formation_app/features/profile/ui/cubits/library/library_cubit.dart';
import 'package:united_formation_app/features/profile/ui/cubits/orders/orders_cubit.dart';
import 'package:united_formation_app/features/profile/ui/cubits/profile/profile_cubit.dart';
import 'package:united_formation_app/features/profile/ui/cubits/support/support_cubit.dart';

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
    // () => AuthRemoteDataSourceImpl(service: sl()),
    // () => AuthRemoteDataSourceImpl(service: sl()), // For mocking purposes
    () => AuthRemoteDataSourceMock(), // For mocking purposes
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  //! Profile
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

  //! Profile
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      connectionChecker: sl(),
    ),
  );

  //? Use Cases
  //! Authentication
  sl.registerLazySingleton(() => LoginUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SendOtpUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(authRepository: sl()));

  //! Profile
  sl.registerLazySingleton(() => GetProfileUseCase(profileRepository: sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(profileRepository: sl()));
  sl.registerLazySingleton(() => GetUserOrdersUseCase(profileRepository: sl()));
  sl.registerLazySingleton(
    () => GetLibraryItemsUseCase(profileRepository: sl()),
  );
  sl.registerLazySingleton(
    () => ContactSupportUseCase(profileRepository: sl()),
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

  //! Profile
  sl.registerFactory(
    () => ProfileCubit(getProfileUseCase: sl(), updateProfileUseCase: sl()),
  );

  sl.registerFactory(() => OrdersCubit(getUserOrdersUseCase: sl()));

  sl.registerFactory(() => LibraryCubit(getLibraryItemsUseCase: sl()));

  sl.registerFactory(() => SupportCubit(contactSupportUseCase: sl()));
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
