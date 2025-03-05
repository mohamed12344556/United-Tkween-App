part of 'forget_password_cubit.dart';

@immutable
abstract class ForgetPasswordState {}

// Initial state
class ForgetPasswordInitial extends ForgetPasswordState {}

// Loading state
class ForgetPasswordLoading extends ForgetPasswordState {}

// Form updated state (for toggling password visibility)
class ForgetPasswordFormUpdated extends ForgetPasswordState {}

// OTP sent successfully state
class ForgetPasswordOtpSent extends ForgetPasswordState {
  final String email;
  
  ForgetPasswordOtpSent({required this.email});
}

// OTP timer update state
class ForgetPasswordOtpTimerUpdated extends ForgetPasswordState {
  final int timeRemaining;
  final String email;
  
  ForgetPasswordOtpTimerUpdated({
    required this.timeRemaining,
    required this.email,
  });
}

// OTP resent state
class ForgetPasswordOtpResent extends ForgetPasswordState {}

// OTP verified successfully state
class ForgetPasswordOtpVerified extends ForgetPasswordState {
  final String email;
  
  ForgetPasswordOtpVerified({required this.email});
}

// Password reset success state
class ForgetPasswordSuccess extends ForgetPasswordState {}

// Error state
class ForgetPasswordError extends ForgetPasswordState {
  final String message;
  
  ForgetPasswordError({required this.message});
}