import 'package:equatable/equatable.dart';

import '../../../domain/entities/profile_entity.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final String? errorMessage;
  final bool isProfileUpdated;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.isProfileUpdated = false,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    String? errorMessage,
    bool? isProfileUpdated,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      isProfileUpdated: isProfileUpdated ?? this.isProfileUpdated,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage, isProfileUpdated];

  // Helper states
  bool get isInitial => status == ProfileStatus.initial;
  bool get isLoading => status == ProfileStatus.loading;
  bool get isSuccess => status == ProfileStatus.success;
  bool get isError => status == ProfileStatus.error;
}