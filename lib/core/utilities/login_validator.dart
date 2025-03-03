
class LoginValidator {
  static String? validateEmail(String? value, bool isTeacher) {
    if (value == null || value.isEmpty) {
      // return S.current.field_required;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      // return S.current.field_required;
    }
    return null;
  }
}