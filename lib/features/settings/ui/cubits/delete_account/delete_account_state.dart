import 'package:equatable/equatable.dart';

enum DeleteAccountStatus { initial, loading, success, error }

// حالة Cubit لحذف الحساب
class DeleteAccountState extends Equatable {
  final DeleteAccountStatus status;
  final String? errorMessage;

  const DeleteAccountState({
    this.status = DeleteAccountStatus.initial,
    this.errorMessage,
  });

  // نسخ الحالة مع تحديث بعض القيم
  DeleteAccountState copyWith({
    DeleteAccountStatus? status,
    String? errorMessage,
  }) {
    return DeleteAccountState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];

  // مساعدون للتحقق من الحالة بسهولة
  bool get isInitial => status == DeleteAccountStatus.initial;
  bool get isLoading => status == DeleteAccountStatus.loading;
  bool get isSuccess => status == DeleteAccountStatus.success;
  bool get isError => status == DeleteAccountStatus.error;
}
