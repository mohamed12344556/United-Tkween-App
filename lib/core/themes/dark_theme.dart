import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_text_styling.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.black,
  brightness: Brightness.dark,
  fontFamily: AppFonts.primaryFont,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ),
  // Text Style:
  textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: AppColors.text,
        displayColor: AppColors.secondary,
        fontFamily: AppFonts.textFont,
      ),
  // Elevated Button Style:
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.background,
      // foregroundColor: AppColors.primary,
      // disabledBackgroundColor: AppColors.primary,
      // disabledForegroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTextStyling.font10W400TextColor,
      elevation: 0,
    ),
  ),
  // Text Field Style:
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey[200]!,
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey[200]!,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey[300]!,
        width: 1,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1),
    ),
    fillColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.focused)) {
        return AppColors.primary;
      }
      return AppColors.primary;
    }),
    filled: true,
    hintStyle:
        AppTextStyling.font10W400TextColor.copyWith(color: AppColors.error),
  ),
  // Divider style:
  dividerTheme: const DividerThemeData(
    color: Colors.grey,
    thickness: 1,
    endIndent: 10,
    indent: 10,
  ),
);
