import 'package:dartz/dartz.dart';
import '../entities/profile_entity.dart';
import '../repos/profile_repository.dart';

import '../../../../core/core.dart';

class GetProfileUseCase extends NoParamUseCase<ApiErrorModel, ProfileEntity> {
  final ProfileRepository profileRepository;

  GetProfileUseCase({required this.profileRepository});

  @override
  Future<Either<ApiErrorModel, ProfileEntity>> call() async {
    return await profileRepository.getProfile();
  }
}
