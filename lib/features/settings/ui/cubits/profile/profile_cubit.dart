// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../domain/usecases/get_profile_usecase.dart';
// import 'profile_state.dart';

// class ProfileCubit extends Cubit<ProfileState> {
//   final GetProfileUseCase _getProfileUseCase;

//   ProfileCubit({
//     required GetProfileUseCase getProfileUseCase,
//   })  : _getProfileUseCase = getProfileUseCase,
//         super(const ProfileState());

//   // تحميل بيانات الملف الشخصي
//   Future<void> loadProfile() async {
//     if (isClosed) return;

//     emit(state.copyWith(status: ProfileStatus.loading));

//     final result = await _getProfileUseCase();

//     if (isClosed) return;

//     result.fold(
//       (error) => emit(
//         state.copyWith(
//           status: ProfileStatus.error,
//           errorMessage:
//               error.errorMessage?? 'خطأ في تحميل الملف الشخصي',
//         ),
//       ),
//       (profile) => emit(
//         state.copyWith(
//           status: ProfileStatus.success,
//           profile: profile,
//         ),
//       ),
//     );
//   }

//   // تعيين حالة التحديث
//   void setProfileUpdated() {
//     if (isClosed) return;

//     emit(
//       state.copyWith(
//         isProfileUpdated: true,
//       ),
//     );
//   }

//   // إعادة تعيين حالة التحديث
//   void resetProfileUpdated() {
//     if (isClosed) return;

//     emit(
//       state.copyWith(
//         isProfileUpdated: false,
//       ),
//     );
//   }
// }

// lib/features/settings/ui/cubits/profile/profile_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;

  ProfileCubit({required GetProfileUseCase getProfileUseCase})
    : _getProfileUseCase = getProfileUseCase,
      super(const ProfileState());

  // تحميل بيانات الملف الشخصي
  Future<void> loadProfile() async {
    if (isClosed) return;

    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _getProfileUseCase();

    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: error.errorMessage ?? 'خطأ في تحميل الملف الشخصي',
        ),
      ),
      (profile) {
        print("Profile loaded with name: ${profile.fullName}"); // للتتبع
        emit(state.copyWith(status: ProfileStatus.success, profile: profile));
      },
    );
  }

  // تعيين حالة التحديث
  void setProfileUpdated() {
    
    if (isClosed) return;

    emit(state.copyWith(isProfileUpdated: true));
  }

  // إعادة تعيين حالة التحديث
  void resetProfileUpdated() {
    if (isClosed) return;

    emit(state.copyWith(isProfileUpdated: false));
  }
}
