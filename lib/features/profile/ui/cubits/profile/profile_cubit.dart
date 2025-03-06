import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:united_formation_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _getProfileUseCase();

    result.fold(
      (error) => emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: error.errorMessage?.message ?? 'خطأ في تحميل الملف الشخصي',
      )),
      (profile) => emit(state.copyWith(
        status: ProfileStatus.success,
        profile: profile,
      )),
    );
  }

  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber1,
    String? phoneNumber2,
    String? address,
  }) async {
    if (state.profile == null) return;

    emit(state.copyWith(status: ProfileStatus.loading));

    final updatedProfile = state.profile!.copyWith(
      fullName: fullName ?? state.profile!.fullName,
      phoneNumber1: phoneNumber1 ?? state.profile!.phoneNumber1,
      phoneNumber2: phoneNumber2 ?? state.profile!.phoneNumber2,
      address: address ?? state.profile!.address,
    );

    final result = await _updateProfileUseCase(updatedProfile);

    result.fold(
      (error) => emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: error.errorMessage?.message ?? 'خطأ في تحديث الملف الشخصي',
      )),
      (success) {
        if (success) {
          emit(state.copyWith(
            status: ProfileStatus.success,
            profile: updatedProfile,
            isEditing: false,
          ));
        } else {
          emit(state.copyWith(
            status: ProfileStatus.error,
            errorMessage: 'فشل تحديث الملف الشخصي',
          ));
        }
      },
    );
  }

  void toggleEditMode() {
    emit(state.copyWith(isEditing: !state.isEditing));
  }

  void cancelEdit() {
    emit(state.copyWith(isEditing: false));
  }
}