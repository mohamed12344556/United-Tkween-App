import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/profile/domain/repos/profile_repository.dart';

import '../../../../core/core.dart';

class ContactSupportUseCase extends UseCase<ApiErrorModel, bool, String> {
  final ProfileRepository profileRepository;

  ContactSupportUseCase({required this.profileRepository});

  @override
  Future<Either<ApiErrorModel, bool>> call(String params) async {
    return await profileRepository.sendSupportMessage(params);
  }
}
