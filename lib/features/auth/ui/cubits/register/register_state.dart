part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

// Initial state
class RegisterInitial extends RegisterState {}

// Loading state during registration process
class RegisterLoading extends RegisterState {}

// State for form updates (like password visibility toggling)
class RegisterFormUpdated extends RegisterState {}

// Success state after successful registration
class RegisterSuccess extends RegisterState {
  final String userID;
  final String userEmail;
  final String? socialProvider; // Optional for social logins

  RegisterSuccess({
    required this.userID,
    required this.userEmail,
    this.socialProvider,
  });
}

// حالة إرسال OTP
class RegisterOtpSent extends RegisterState {
  final String email;
  
  RegisterOtpSent({required this.email});
}

// Error state
class RegisterError extends RegisterState {
  final String errorMessage;

  RegisterError({required this.errorMessage});
}