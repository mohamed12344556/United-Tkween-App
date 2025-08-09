import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void changeTheme(ThemeMode mode) {
    emit(mode);
  }

  // Reset theme to system default
  void resetToSystem() {
    emit(ThemeMode.system);
  }

  // Check if current theme is system
  bool get isSystemMode => state == ThemeMode.system;

  final String _jsonKey = "themeMode";

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    // Always return system mode if no preference is saved or if preference is system
    final savedMode = json[_jsonKey];
    if (savedMode == "light") {
      return ThemeMode.light;
    } else if (savedMode == "dark") {
      return ThemeMode.dark;
    } else {
      // Default to system for any other case (including null)
      return ThemeMode.system;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    // Save the current state
    switch (state) {
      case ThemeMode.light:
        return {_jsonKey: "light"};
      case ThemeMode.dark:
        return {_jsonKey: "dark"};
      case ThemeMode.system:
      default:
        return {_jsonKey: "system"};
    }
  }
}
