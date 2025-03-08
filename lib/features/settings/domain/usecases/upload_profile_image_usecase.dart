import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/settings/domain/repos/profile_repository.dart';

import '../../../../core/core.dart';

class UploadProfileImageUseCase extends UseCase<ApiErrorModel, String, File> {
  final ProfileRepository profileRepository;

  UploadProfileImageUseCase({required this.profileRepository});
  
  @override
  Future<Either<ApiErrorModel, String>> call(File params) {
    // TODO: implement call
    throw UnimplementedError();
  }

  
}

