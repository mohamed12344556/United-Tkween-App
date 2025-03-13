import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/api_error_model.dart';
import '../../../data/models/support_message_model.dart';
import '../../../domain/repos/admin_repository.dart';

part 'support_admin_state.dart';

class SupportAdminCubit extends Cubit<SupportAdminState> {
  final AdminRepository repository;

  SupportAdminCubit({required this.repository}) : super(SupportInitial());

  Future<void> loadMessages() async {
    emit(SupportLoading());
    final result = await repository.getSupportMessages();
    emit(
      result.fold(
        (failure) => SupportError(message: _mapFailureToMessage(failure)),
        (messages) => SupportLoaded(messages),
      ),
    );
  }

  Future<void> sendMessage(String customerId, String message) async {
    emit(SupportLoading());
    final result = await repository.sendSupportMessage(customerId, message);
    result.fold(
      (failure) => emit(SupportError(message: _mapFailureToMessage(failure))),
      (_) async {
        // Reload the messages after sending
        await loadMessages();
      },
    );
  }

  Future<void> markMessageAsRead(String messageId) async {
    emit(SupportLoading());
    final result = await repository.markMessageAsRead(messageId);
    result.fold(
      (failure) => emit(SupportError(message: _mapFailureToMessage(failure))),
      (_) async {
        // Reload the messages after marking as read
        await loadMessages();
      },
    );
  }

  String _mapFailureToMessage(ApiErrorModel failure) {
    return failure.errorMessage?.message ?? "حدث خطأ غير متوقع";
  }
}
