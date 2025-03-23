part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

// الحالة الأولية
class RegisterInitial extends RegisterState {}

// حالة التحميل أثناء عملية التسجيل
class RegisterLoading extends RegisterState {}

// حالة تحديثات النموذج (مثل تبديل رؤية كلمة المرور)
class RegisterFormUpdated extends RegisterState {}

// حالة النجاح بعد التسجيل الناجح
class RegisterSuccess extends RegisterState {
  final String userEmail;
  final String? socialProvider; // اختياري للتسجيل بوسائل التواصل الاجتماعي

  RegisterSuccess({
    required this.userEmail,
    this.socialProvider,
  });
}

// حالة الخطأ
class RegisterError extends RegisterState {
  final String errorMessage;

  RegisterError({required this.errorMessage});
}