import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/profile/domain/repos/profile_repository.dart';
import '../../../../core/core.dart';
import '../entities/library_item_entity.dart';

class GetLibraryItemsUseCase extends NoParamUseCase<ApiErrorModel, List<LibraryItemEntity>> {
  final ProfileRepository profileRepository;

  GetLibraryItemsUseCase({required this.profileRepository});

  @override
  Future<Either<ApiErrorModel, List<LibraryItemEntity>>> call() async {
    return await profileRepository.getLibraryItems();
  }
}