import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/contact_support_usecase.dart';
import 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  final ContactSupportUseCase _contactSupportUseCase;

  SupportCubit({
    required ContactSupportUseCase contactSupportUseCase,
  })  : _contactSupportUseCase = contactSupportUseCase,
        super(const SupportState());

  void updateMessage(String message) {
    emit(state.copyWith(message: message));
  }

  Future<void> sendMessage() async {
    if (state.message == null || state.message!.trim().isEmpty) {
      emit(state.copyWith(
        status: SupportStatus.error,
        errorMessage: 'الرجاء إدخال رسالة',
      ));
      return;
    }

    emit(state.copyWith(status: SupportStatus.loading));

    final result = await _contactSupportUseCase(state.message!);

    result.fold(
      (error) => emit(state.copyWith(
        status: SupportStatus.error,
        errorMessage: error.errorMessage?.message ?? 'خطأ في إرسال الرسالة',
      )),
      (success) {
        if (success) {
          emit(state.copyWith(
            status: SupportStatus.success,
            messageSent: true,
            message: '',
          ));
        } else {
          emit(state.copyWith(
            status: SupportStatus.error,
            errorMessage: 'فشل إرسال الرسالة',
          ));
        }
      },
    );
  }

  void resetState() {
    emit(const SupportState());
  }
}