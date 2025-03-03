import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_text_styling.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  brightness: Brightness.light,
  fontFamily: AppFonts.primaryFont,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: AppColors.text,
        displayColor: AppColors.secondary,
        fontFamily: AppFonts.textFont,
      ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
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
      return AppColors.error;
    }),
    filled: true,
    hintStyle:
        AppTextStyling.font10W400TextColor.copyWith(color: AppColors.error),
  ),
  switchTheme: const SwitchThemeData(
    thumbColor: WidgetStatePropertyAll(AppColors.primary),
    trackColor: WidgetStatePropertyAll(AppColors.primary),
    trackOutlineColor: WidgetStatePropertyAll(AppColors.primary),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: AppColors.primary,
    elevation: 0,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.primary,
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.grey,
    thickness: 1,
    endIndent: 10,
    indent: 10,
  ),
);
