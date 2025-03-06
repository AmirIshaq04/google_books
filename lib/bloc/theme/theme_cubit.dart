import 'package:book_finder_flutter/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(AppTheme.lightTheme) {
    _loadTheme();
  }

  static const String _themeKey = 'isDarkMode';
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_themeKey) ?? false;
    emit(isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme);
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state.brightness == Brightness.light) {
      emit(AppTheme.darkTheme);
      await prefs.setBool(_themeKey, true);
    } else {
      emit(AppTheme.lightTheme);
      await prefs.setBool(_themeKey, false);
    }
  }
}