part of 'otp_cubit.dart';

@immutable
abstract class OtpState {}

// Initial state
class OtpInitial extends OtpState {}

// Loading state
class OtpLoading extends OtpState {}

// Timer update state
class OtpTimerUpdated extends OtpState {
  final int timeRemaining;

  OtpTimerUpdated({required this.timeRemaining});
}

// OTP resent successfully
class OtpResent extends OtpState {}

// OTP verified successfully
class OtpVerified extends OtpState {
  final OtpPurpose purpose;

  OtpVerified({required this.purpose});
}

// Error state
class OtpError extends OtpState {
  final String message;

  OtpError({required this.message});
}