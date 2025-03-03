class ValidatorUtils {
  static bool isOnlyNumbersWithoutDecimal(String value) {
    return RegExp(r'^\d+$').hasMatch(value);
  }

  static bool isOnlyNumbersWithDecimal(String value) {
    return RegExp(r'^\d*\.?\d*$').hasMatch(value);
  }

  static bool isEmail(String? value) {
    if (!hasValue(value)) {
      return false;
    }
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value!);
  }

  static bool isName(String value) {
    if (!hasValue(value)) {
      return false;
    }
    return RegExp(r"^[\p{L}\p{M}'\-\s]+$", unicode: true).hasMatch(value);
  }

  static bool isPhoneNumber(String value) {
    if (!hasValue(value)) {
      return false;
    }
    return RegExp(r'^\+?([0-9]{10,15})$').hasMatch(value);
  }

  static bool isPhoneNumberOrEmpty(String? value) {
    if (!hasValue(value)) {
      return true;
    }
    return RegExp(r'^\+?([0-9]{10,15})$').hasMatch(value!);
  }

  static bool hasValue(String? value) {
    return !(value == null || value.isEmpty);
  }

  static bool isLink(String value) {
    if (!hasValue(value)) {
      return false;
    }

    final regex = RegExp(r"^https?:\/\/" // Match http or https
        r"([\da-z\.-]+)\.([a-z\.]{2,6})" // Match domain name
        r"([\/\w \.-]*)*\/?$" // Match path (optional)
        );

    return regex.hasMatch(value);
  }

  static bool isPassword(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.length < 8 ||
        !RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$').hasMatch(value)) {
      return false;
    }
    return true;
  }

  // static bool isFullName(String value, {String? selectedCountryCode}) {
  //   bool? hasAtLeastTwoNames;
  //   // Check if the name is not empty and contains only valid characters
  //   // Allow letters from any language, spaces, hyphens, and apostrophes
  //   if (!hasValue(value)) {
  //     return false;
  //   }

  //   // The updated regex pattern includes Unicode characters for letters from any language
  //   bool isValidCharacters =
  //       RegExp(r"^[\p{L}\p{M}'\-\s]+$", unicode: true).hasMatch(value);

  //   // Split the name into parts and check if at least two names are provided
  //   // Split on one or more spaces
  //   var parts = value.trim().split(RegExp(r"\s+"));

  //   if (selectedCountryCode != null) {
  //     if (selectedCountryCode == 'EG') {
  //       hasAtLeastTwoNames = parts.length >= 4;
  //     } else {
  //       hasAtLeastTwoNames = parts.length >= 2;
  //     }
  //   } else {
  //     hasAtLeastTwoNames = parts.length >= 2;
  //   }
  //   bool allPartsValid = parts.every((part) => part.length >= 2);
  //   return isValidCharacters && hasAtLeastTwoNames && allPartsValid;
  // }

  // static bool isFullName(String value, {String? selectedCountryCode}) {
  //   if (!hasValue(value)) return false;
  //   final RegExp validCharacterPattern =
  //       RegExp(r"^[\p{L}\p{M}'\-\s]+$", unicode: true);

  //   // Trim and split the name into parts (words)
  //   final parts = value.trim().split(RegExp(r"\s+"));

  //   // Check if the name contains valid characters
  //   if (!validCharacterPattern.hasMatch(value)) return false;

  //   // Determine the minimum required parts based on the country code
  //   final requiredParts = (selectedCountryCode == 'EG') ? 4 : 2;

  //   // Check if the number of parts and each part length are valid
  //   return parts.length >= requiredParts &&
  //       parts.every((part) => part.length >= 2);
  // }
  static bool isFullName(String value) {
    // Check if the name is not empty and contains only valid characters
    // Allow letters from any language, spaces, hyphens, and apostrophes
    if (!hasValue(value)) {
      return false;
    }

    // The updated regex pattern includes Unicode characters for letters from any language
    bool isValidCharacters =
        RegExp(r"^[\p{L}\p{M}'\-\s]+$", unicode: true).hasMatch(value);

    // Split the name into parts and check if at least two names are provided
    var parts =
        value.trim().split(RegExp(r"\s+")); // Split on one or more spaces
    bool hasAtLeastTwoNames = parts.length >= 2;

    bool allPartsValid = parts.every((part) => part.length >= 2);

    return isValidCharacters && hasAtLeastTwoNames && allPartsValid;
  }

  static bool isEgyptianFullName(String value) {
    // Check if the name is not empty and contains only valid characters
    // Allow letters from any language, spaces, hyphens, and apostrophes
    if (!hasValue(value)) {
      return false;
    }

    // The updated regex pattern includes Unicode characters for letters from any language
    bool isValidCharacters =
        RegExp(r"^[\p{L}\p{M}'\-\s]+$", unicode: true).hasMatch(value);

    // Split the name into parts and check if at least four names are provided
    var parts =
        value.trim().split(RegExp(r"\s+")); // Split on one or more spaces
    bool hasAtLeastFourNames = parts.length == 4;

    bool allPartsValid = parts.every((part) => part.length >= 2);

    return isValidCharacters && hasAtLeastFourNames && allPartsValid;
  }

  static bool isNationalId(String value, String selectedCountryCode) {
    if (!hasValue(value)) {
      return false;
    }
    if (selectedCountryCode == 'EG') {
      return value.length == 14;
    } else {
      return value.length >= 6 && value.length <= 9;
    }
  }

  static bool isPositiveIntOrDouble(String value, double limit) {
    if (!hasValue(value)) {
      return false;
    }
    try {
      double parsedValue = double.parse(value);
      return parsedValue > 0 && parsedValue <= limit;
    } catch (e) {
      return false; // If parsing fails, return false
    }
  }

  static bool isPositiveNumberGreaterThanOrEqual({
    required String value,
    required double minValue,
  }) {
    if (!hasValue(value)) {
      return false;
    }
    final regex = RegExp(r'^\d+(\.\d+)?$');
    if (!regex.hasMatch(value)) {
      return false;
    }
    final double number = double.parse(value);
    return number >= minValue;
  }

  static bool isEnglishLetters(String value) {
    return RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value);
  }

  static bool isArabicLetters(String value) {
    return RegExp(r'^[\u0600-\u06FF0-9\s]+$').hasMatch(value);
  }

  static bool isPassport(String value) {
    return RegExp(r'^[A-Za-z0-9]{6,9}$').hasMatch(value);
  }

  // 1. Job Title Validation (Assuming a job title should contain letters and possibly some special characters like spaces or hyphens)
  static bool isJobTitle(String value) {
    if (!hasValue(value)) {
      return false;
    }
    // Allow letters, hyphens, and spaces (Assumed format for job titles)
    return RegExp(r"^[\p{L}\p{M}'\-\s]+$", unicode: true).hasMatch(value);
  }

  // 2. Company Name Validation (Allow letters, numbers, spaces, and some special characters)
  static bool isCompany(String value) {
    if (!hasValue(value)) {
      return false;
    }
    // Allow letters, numbers, hyphens, and spaces (Assumed format for company names)
    return RegExp(r"^[\p{L}\p{M}\d\-\s]+$", unicode: true).hasMatch(value);
  }

  // 3. Company Website Validation (Reuse the isLink function for this)
  static bool isCompanyWebsite(String value) {
    return isLink(value);
  }
}
