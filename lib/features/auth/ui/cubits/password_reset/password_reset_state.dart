part of 'password_reset_cubit.dart';

@immutable
abstract class PasswordResetState {}

// الحالة الأولية
class PasswordResetInitial extends PasswordResetState {}

// حالة التحميل
class PasswordResetLoading extends PasswordResetState {}

// حالة تحديث نموذج
class PasswordResetFormUpdated extends PasswordResetState {}

// حالة نجاح إعادة تعيين كلمة المرور
class PasswordResetSuccess extends PasswordResetState {}

// حالة خطأ
class PasswordResetError extends PasswordResetState {
  final String message;

  PasswordResetError({required this.message});
}