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
    primary: AppColors.primary,
    onPrimary: Colors.black,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    surface: Colors.white,
    background: AppColors.background,
    error: AppColors.error,
  ),
  // Text Style:
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: AppColors.text,
    displayColor: Colors.black,
    fontFamily: AppFonts.textFont,
  ),
  // Elevated Button Style:
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.black,
      disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
      disabledForegroundColor: Colors.black.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      textStyle: AppTextStyling.font10W400TextColor.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 15),
    ),
  ),
  // Text Button Style:
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
    ),
  ),
  // Text Field Style:
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
    fillColor: Colors.white,
    filled: true,
    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
    prefixIconColor: Colors.grey[600],
    suffixIconColor: Colors.grey[600],
  ),
  // Chip Theme:
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.unselectedChip,
    selectedColor: AppColors.selectedChip,
    labelStyle: const TextStyle(
      color: AppColors.text,
      fontWeight: FontWeight.w500,
    ),
    secondaryLabelStyle: const TextStyle(
      color: AppColors.text,
      fontWeight: FontWeight.w500,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    side: BorderSide(color: Colors.grey[300]!),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  ),
  // Switch Theme:
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.black;
      }
      return Colors.white;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return Colors.grey[300];
    }),
    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  ),
  // Bottom App Bar:
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.white,
    elevation: 8,
    shadowColor: Colors.black12,
  ),
  // Bottom Sheet:
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    modalElevation: 8,
  ),
  // Divider style:
  dividerTheme: DividerThemeData(
    color: Colors.grey[300]!,
    thickness: 1,
    endIndent: 10,
    indent: 10,
  ),
  // Card Theme:
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  // App Bar Theme:
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: AppFonts.primaryFont,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    iconTheme: const IconThemeData(color: Colors.black),
  ),
  // Bottom Navigation Bar:
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: Colors.grey[600],
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
  ),
  // Floating Action Button:
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.black,
    elevation: 4,
    shape: CircleBorder(),
  ),
  // Dialog Theme:
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);
