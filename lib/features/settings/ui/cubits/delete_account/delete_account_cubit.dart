import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/settings/domain/usecases/delete_account_usecase.dart';
import 'package:united_formation_app/features/settings/ui/cubits/delete_account/delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final DeleteAccountUseCase _deleteAccountUseCase;

  DeleteAccountCubit({required DeleteAccountUseCase deleteAccountUseCase})
      : _deleteAccountUseCase = deleteAccountUseCase,
        super(const DeleteAccountState());

  // تنفيذ حذف الحساب
  Future<void> deleteAccount() async {
    emit(state.copyWith(status: DeleteAccountStatus.loading));

    final result = await _deleteAccountUseCase();

    result.fold(
      (error) => emit(state.copyWith(
        status: DeleteAccountStatus.error,
        // استخدام معالج الأخطاء الصديق للمستخدم
        errorMessage: error.errorMessage ?? 'حدث خطأ أثناء حذف الحساب',
      )),
      (success) => emit(state.copyWith(status: DeleteAccountStatus.success)),
    );
  }

  // إعادة تعيين الحالة
  void resetState() {
    emit(const DeleteAccountState());
  }
}