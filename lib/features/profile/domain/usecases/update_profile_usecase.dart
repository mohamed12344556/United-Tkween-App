import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/profile/domain/repos/profile_repository.dart';
import '../../../../core/core.dart';
import '../entities/profile_entity.dart';

class UpdateProfileUseCase extends UseCase<ApiErrorModel, bool, ProfileEntity> {
  final ProfileRepository profileRepository;

  UpdateProfileUseCase({required this.profileRepository});

  @override
  Future<Either<ApiErrorModel, bool>> call(ProfileEntity params) async {
    return await profileRepository.updateProfile(params);
  }
}