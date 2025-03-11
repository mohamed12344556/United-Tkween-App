import 'package:equatable/equatable.dart';

import '../../../domain/entities/profile_entity.dart';


enum EditProfileStatus { initial, loading, success, error }

class EditProfileState extends Equatable {
  final EditProfileStatus status;
  final ProfileEntity? profile;
  final String? errorMessage;
  final bool isUpdated;

  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.isUpdated = false,
  });

  EditProfileState copyWith({
    EditProfileStatus? status,
    ProfileEntity? profile,
    String? errorMessage,
    bool? isUpdated,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      isUpdated: isUpdated ?? this.isUpdated,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage, isUpdated];

  // Helper states
  bool get isInitial => status == EditProfileStatus.initial;
  bool get isLoading => status == EditProfileStatus.loading;
  bool get isSuccess => status == EditProfileStatus.success;
  bool get isError => status == EditProfileStatus.error;
}