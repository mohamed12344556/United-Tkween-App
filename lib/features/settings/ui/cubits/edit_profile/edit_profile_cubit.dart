// import 'dart:io';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../domain/usecases/get_profile_usecase.dart';
// import '../../../domain/usecases/update_profile_usecase.dart';
// import '../../../domain/usecases/upload_profile_image_usecase.dart';
// import '../../../domain/usecases/remove_profile_image_usecase.dart';
// import 'edit_profile_state.dart';

// class EditProfileCubit extends Cubit<EditProfileState> {
//   final GetProfileUseCase _getProfileUseCase;
//   final UpdateProfileUseCase _updateProfileUseCase;
//   final UploadProfileImageUseCase _uploadProfileImageUseCase;
//   final RemoveProfileImageUseCase _removeProfileImageUseCase;

//   EditProfileCubit({
//     required GetProfileUseCase getProfileUseCase,
//     required UpdateProfileUseCase updateProfileUseCase,
//     required UploadProfileImageUseCase uploadProfileImageUseCase,
//     required RemoveProfileImageUseCase removeProfileImageUseCase,
//   })  : _getProfileUseCase = getProfileUseCase,
//         _updateProfileUseCase = updateProfileUseCase,
//         _uploadProfileImageUseCase = uploadProfileImageUseCase,
//         _removeProfileImageUseCase = removeProfileImageUseCase,
//         super(const EditProfileState());

//   // تحميل بيانات الملف الشخصي
//   Future<void> loadProfile() async {
//     if (isClosed) return;

//     emit(state.copyWith(status: EditProfileStatus.loading));

//     final result = await _getProfileUseCase();

//     if (isClosed) return;

//     result.fold(
//       (error) => emit(
//         state.copyWith(
//           status: EditProfileStatus.error,
//           errorMessage:
//               error.errorMessage?? 'خطأ في تحميل الملف الشخصي',
//         ),
//       ),
//       (profile) => emit(
//         state.copyWith(
//           status: EditProfileStatus.success,
//           profile: profile,
//           isUpdated: false,
//         ),
//       ),
//     );
//   }

//   // تحديث بيانات الملف الشخصي
//   Future<void> updateProfile({
//     String? fullName,
//     String? phoneNumber1,
//     String? phoneNumber2,
//     String? address,
//     File? profileImage,
//   }) async {
//     if (state.profile == null || isClosed) return;

//     emit(state.copyWith(status: EditProfileStatus.loading));

//     // Handle image upload first if there's a new image
//     String? profileImageUrl = state.profile!.profileImageUrl;
//     if (profileImage != null) {
//       // Upload the new image and get the URL
//       final imageResult = await _uploadProfileImageUseCase(profileImage);

//       if (isClosed) return;

//       // Update the profile image URL if upload was successful
//       imageResult.fold(
//         (error) {
//           emit(state.copyWith(
//             status: EditProfileStatus.error,
//             errorMessage: error.errorMessage?? 'خطأ في تحميل الصورة',
//           ));
//           return; // Exit early if image upload failed
//         },
//         (imageUrl) {
//           profileImageUrl = imageUrl;
//         },
//       );

//       // Return if we encountered an error during image upload
//       if (state.status == EditProfileStatus.error) return;
//     }

//     // Create updated profile with new data
//     final updatedProfile = state.profile!.copyWith(
//       fullName: fullName ?? state.profile!.fullName,
//       phoneNumber1: phoneNumber1 ?? state.profile!.phoneNumber1,
//       phoneNumber2: phoneNumber2 ?? state.profile!.phoneNumber2,
//       address: address ?? state.profile!.address,
//       profileImageUrl: profileImageUrl,
//     );

//     // Update the profile with all data including the new image URL
//     final result = await _updateProfileUseCase(updatedProfile);

//     if (isClosed) return;

//     result.fold(
//       (error) => emit(
//         state.copyWith(
//           status: EditProfileStatus.error,
//           errorMessage:
//               error.errorMessage?? 'خطأ في تحديث الملف الشخصي',
//         ),
//       ),
//       (success) {
//         if (success) {
//           emit(
//             state.copyWith(
//               status: EditProfileStatus.success,
//               profile: updatedProfile,
//               isUpdated: true,
//             ),
//           );
//         } else {
//           emit(
//             state.copyWith(
//               status: EditProfileStatus.error,
//               errorMessage: 'فشل تحديث الملف الشخصي',
//             ),
//           );
//         }
//       },
//     );
//   }

//   // تحديث صورة الملف الشخصي
//   Future<void> updateProfileImage(File imageFile) async {
//     if (state.profile == null || isClosed) return;

//     emit(state.copyWith(status: EditProfileStatus.loading));

//     // Upload the image
//     final result = await _uploadProfileImageUseCase(imageFile);

//     if (isClosed) return;

//     result.fold(
//       (error) => emit(
//         state.copyWith(
//           status: EditProfileStatus.error,
//           errorMessage: error.errorMessage?? 'خطأ في تحميل الصورة',
//         ),
//       ),
//       (imageUrl) {
//         // If image upload was successful, update the profile with the new image URL
//         final updatedProfile = state.profile!.copyWith(
//           profileImageUrl: imageUrl,
//         );

//         // Update the profile in state
//         emit(
//           state.copyWith(
//             status: EditProfileStatus.success,
//             profile: updatedProfile,
//             isUpdated: true,
//           ),
//         );
//       },
//     );
//   }

//   // إزالة صورة الملف الشخصي
//   Future<void> removeProfileImage() async {
//     if (state.profile == null || isClosed) return;

//     emit(state.copyWith(status: EditProfileStatus.loading));

//     // Call the remove profile image use case
//     final result = await _removeProfileImageUseCase(state.profile!.id);

//     if (isClosed) return;

//     result.fold(
//       (error) => emit(
//         state.copyWith(
//           status: EditProfileStatus.error,
//           errorMessage: error.errorMessage?? 'خطأ في إزالة الصورة',
//         ),
//       ),
//       (success) {
//         if (success) {
//           // If removal was successful, update the profile with null image URL
//           final updatedProfile = state.profile!.copyWith(
//             profileImageUrl: null,
//           );

//           // Update the profile in state
//           emit(
//             state.copyWith(
//               status: EditProfileStatus.success,
//               profile: updatedProfile,
//               isUpdated: true,
//             ),
//           );
//         } else {
//           emit(
//             state.copyWith(
//               status: EditProfileStatus.error,
//               errorMessage: 'فشل إزالة صورة الملف الشخصي',
//             ),
//           );
//         }
//       },
//     );
//   }
// }


import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_profile_usecase.dart';
import '../../../domain/usecases/update_profile_usecase.dart';
import '../../../domain/usecases/upload_profile_image_usecase.dart';
import '../../../domain/usecases/remove_profile_image_usecase.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  final RemoveProfileImageUseCase _removeProfileImageUseCase;

  EditProfileCubit({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required UploadProfileImageUseCase uploadProfileImageUseCase,
    required RemoveProfileImageUseCase removeProfileImageUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       _uploadProfileImageUseCase = uploadProfileImageUseCase,
       _removeProfileImageUseCase = removeProfileImageUseCase,
       super(const EditProfileState());

  // تحميل بيانات الملف الشخصي
  Future<void> loadProfile() async {
    if (isClosed) return;

    emit(state.copyWith(status: EditProfileStatus.loading));

    final result = await _getProfileUseCase();

    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          status: EditProfileStatus.error,
          errorMessage: error.errorMessage ?? 'خطأ في تحميل الملف الشخصي',
        ),
      ),
      (profile) => emit(
        state.copyWith(
          status: EditProfileStatus.success,
          profile: profile,
          isUpdated: false,
        ),
      ),
    );
  }

  // تحديث بيانات الملف الشخصي
  // Future<void> updateProfile({
  //   String? fullName,
  //   String? phoneNumber1,
  //   String? phoneNumber2,
  //   String? address,
  // }) async {
  //   if (state.profile == null || isClosed) return;

  //   emit(state.copyWith(status: EditProfileStatus.loading));

  //   // إنشاء ملف شخصي محدث بالبيانات الجديدة
  //   final updatedProfile = state.profile!.copyWith(
  //     fullName: fullName ?? state.profile!.fullName,
  //     phoneNumber1: phoneNumber1 ?? state.profile!.phoneNumber1,
  //     phoneNumber2: phoneNumber2 ?? state.profile!.phoneNumber2,
  //     address: address ?? state.profile!.address,
  //     // نحافظ على profileImageUrl كما هو
  //   );

  //   // تحديث الملف الشخصي بالبيانات الجديدة
  //   final result = await _updateProfileUseCase(updatedProfile);

  //   if (isClosed) return;

  //   result.fold(
  //     (error) => emit(
  //       state.copyWith(
  //         status: EditProfileStatus.error,
  //         errorMessage: error.errorMessage ?? 'خطأ في تحديث الملف الشخصي',
  //       ),
  //     ),
  //     (success) {
  //       if (success) {
  //         emit(
  //           state.copyWith(
  //             status: EditProfileStatus.success,
  //             profile: updatedProfile,
  //             isUpdated: true,
  //           ),
  //         );
  //       } else {
  //         emit(
  //           state.copyWith(
  //             status: EditProfileStatus.error,
  //             errorMessage: 'فشل تحديث الملف الشخصي',
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  // في وظيفة updateProfile داخل EditProfileCubit
  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber1,
    String? address,
  }) async {
    if (state.profile == null || isClosed) return;

    // تغيير الحالة إلى loading
    emit(state.copyWith(status: EditProfileStatus.loading));

    // إنشاء ملف شخصي محدث بالبيانات الجديدة
    final updatedProfile = state.profile!.copyWith(
      fullName: fullName ?? state.profile!.fullName,
      phoneNumber1: phoneNumber1 ?? state.profile!.phoneNumber1,
      address: address ?? state.profile!.address,
    );

    // تحديث الملف الشخصي بالبيانات الجديدة
    final result = await _updateProfileUseCase(updatedProfile);

    if (isClosed) return;

    // معالجة نتيجة الاستدعاء
    result.fold(
      (error) => emit(
        state.copyWith(
          status: EditProfileStatus.error,
          errorMessage: error.errorMessage ?? 'خطأ في تحديث الملف الشخصي',
        ),
      ),
      (success) {
        // هنا المشكلة: يجب تغيير الحالة إلى success حتى في حالة الفشل
        if (success) {
          emit(
            state.copyWith(
              status: EditProfileStatus.success,
              profile: updatedProfile,
              isUpdated: true,
            ),
          );
        } else {
          // عند الفشل، قم بإرجاع حالة error وليس الإبقاء على loading
          emit(
            state.copyWith(
              status: EditProfileStatus.error,
              errorMessage: 'فشل تحديث الملف الشخصي',
            ),
          );
        }
      },
    );
  }

  // تحديث صورة الملف الشخصي
  Future<void> updateProfileImage(File imageFile) async {
    if (state.profile == null || isClosed) return;

    emit(state.copyWith(status: EditProfileStatus.loading));

    // تحميل الصورة
    final result = await _uploadProfileImageUseCase(imageFile);

    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          status: EditProfileStatus.error,
          errorMessage: error.errorMessage ?? 'خطأ في تحميل الصورة',
        ),
      ),
      (imageUrl) {
        // إذا نجح تحميل الصورة، قم بتحديث الملف الشخصي برابط الصورة الجديد
        final updatedProfile = state.profile!.copyWith(
          profileImageUrl: imageUrl,
        );

        // تحديث الملف الشخصي في الحالة
        emit(
          state.copyWith(
            status: EditProfileStatus.success,
            profile: updatedProfile,
            isUpdated: true,
          ),
        );
      },
    );
  }

  // إزالة صورة الملف الشخصي
  Future<void> removeProfileImage() async {
    if (state.profile == null || isClosed) return;

    emit(state.copyWith(status: EditProfileStatus.loading));

    // استدعاء حالة استخدام إزالة صورة الملف الشخصي
    final result = await _removeProfileImageUseCase(null);

    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          status: EditProfileStatus.error,
          errorMessage: error.errorMessage ?? 'خطأ في إزالة الصورة',
        ),
      ),
      (success) {
        if (success) {
          // إذا نجحت الإزالة، قم بتحديث الملف الشخصي بجعل رابط الصورة فارغًا
          final updatedProfile = state.profile!.copyWith(profileImageUrl: null);

          // تحديث الملف الشخصي في الحالة
          emit(
            state.copyWith(
              status: EditProfileStatus.success,
              profile: updatedProfile,
              isUpdated: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: EditProfileStatus.error,
              errorMessage: 'فشل إزالة صورة الملف الشخصي',
            ),
          );
        }
      },
    );
  }
}
