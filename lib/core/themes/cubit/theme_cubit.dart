import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void changeTheme(ThemeMode mode) {
    emit(mode);
  }

  final String _jsonKey = "themeMode";
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    if (json[_jsonKey] == "light") {
      return ThemeMode.light;
    } else if (json[_jsonKey] == "dark") {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    if (state == ThemeMode.light) {
      return {
        _jsonKey: "light",
      };
    } else if (state == ThemeMode.dark) {
      return {
        _jsonKey: "dark",
      };
    } else {
      return {
        _jsonKey: "system",
      };
    }
  }
}
