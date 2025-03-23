import 'package:equatable/equatable.dart';

enum SupportStatus { initial, loading, success, error }

class SupportState extends Equatable {
  final SupportStatus status;
  final String? message;
  final String? errorMessage;
  final bool messageSent;

  const SupportState({
    this.status = SupportStatus.initial,
    this.message,
    this.errorMessage,
    this.messageSent = false,
  });

  SupportState copyWith({
    SupportStatus? status,
    String? message,
    String? errorMessage,
    bool? messageSent,
  }) {
    return SupportState(
      status: status ?? this.status,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      messageSent: messageSent ?? this.messageSent,
    );
  }

  @override
  List<Object?> get props => [status, message, errorMessage, messageSent];

  // Helper states
  bool get isInitial => status == SupportStatus.initial;
  bool get isLoading => status == SupportStatus.loading;
  bool get isSuccess => status == SupportStatus.success;
  bool get isError => status == SupportStatus.error;
}