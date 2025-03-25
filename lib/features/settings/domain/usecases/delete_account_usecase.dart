import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/auth/data/services/delete_account_service.dart';

import '../../../../core/core.dart';

class DeleteAccountUseCase extends NoParamUseCase<ApiErrorModel, bool> {
  final DeleteAccountService _deleteAccountService;

  DeleteAccountUseCase({required DeleteAccountService deleteAccountService})
    : _deleteAccountService = deleteAccountService;

  @override
  Future<Either<ApiErrorModel, bool>> call() async {
    return await _deleteAccountService.deleteAccount();
  }
}
