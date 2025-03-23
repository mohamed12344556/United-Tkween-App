import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/settings/domain/repos/profile_repository.dart';

import '../../../../core/core.dart';

class RemoveProfileImageUseCase extends UseCase<ApiErrorModel, bool, void> {
  final ProfileRepository profileRepository;

  RemoveProfileImageUseCase({required this.profileRepository});

  @override
  Future<Either<ApiErrorModel, bool>> call(void params) {
    return profileRepository.removeProfileImage();
  }
}
