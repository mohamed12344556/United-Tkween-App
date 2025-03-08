import 'package:dartz/dartz.dart';
import '../repos/profile_repository.dart';
import '../../../../core/core.dart';
import '../entities/user_order_entity.dart';

class GetUserOrdersUseCase extends NoParamUseCase<ApiErrorModel, List<UserOrderEntity>> {
  final ProfileRepository profileRepository;

  GetUserOrdersUseCase({required this.profileRepository});

  @override
  Future<Either<ApiErrorModel, List<UserOrderEntity>>> call() async {
    return await profileRepository.getUserOrders();
  }
}