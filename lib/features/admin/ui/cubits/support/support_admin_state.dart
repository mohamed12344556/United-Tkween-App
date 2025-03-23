part of 'support_admin_cubit.dart';

abstract class SupportAdminState extends Equatable {
  const SupportAdminState();

  @override
  List<Object> get props => [];
}

class SupportInitial extends SupportAdminState {}

class SupportLoading extends SupportAdminState {}

class SupportLoaded extends SupportAdminState {
  final List<SupportMessageModel> messages;

  const SupportLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class SupportError extends SupportAdminState {
  final String message;

  const SupportError({required this.message});

  @override
  List<Object> get props => [message];
}
