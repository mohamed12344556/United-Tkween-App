part of 'password_reset_cubit.dart';

@immutable
abstract class PasswordResetState {}

// Initial state
class PasswordResetInitial extends PasswordResetState {}

// Loading state
class PasswordResetLoading extends PasswordResetState {}

// Form updated state (for toggling password visibility)
class PasswordResetFormUpdated extends PasswordResetState {}

// OTP sent successfully state
class PasswordResetOtpSent extends PasswordResetState {
  final String email;
  
  PasswordResetOtpSent({required this.email});
}

// OTP timer update state
class PasswordResetOtpTimerUpdated extends PasswordResetState {
  final int timeRemaining;
  final String email;
  
  PasswordResetOtpTimerUpdated({
    required this.timeRemaining,
    required this.email,
  });
}

// OTP resent state
class PasswordResetOtpResent extends PasswordResetState {}

// OTP verified successfully state
class PasswordResetOtpVerified extends PasswordResetState {
  final String email;
  
  PasswordResetOtpVerified({required this.email});
}

// Password reset success state
class PasswordResetSuccess extends PasswordResetState {}

// Error state
class PasswordResetError extends PasswordResetState {
  final String message;
  
  PasswordResetError({required this.message});
}