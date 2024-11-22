import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) {
    _loadTheme();
  }

  static const _boxName = 'app_settings';
  static const _isDarkModeKey = 'is_dark_mode';
  Box? _box;

  Future<void> _loadTheme() async {
    try {
      _box = await Hive.openBox(_boxName);
      final savedTheme = _box?.get(_isDarkModeKey, defaultValue: false);
      state = savedTheme is bool ? savedTheme : false;
    } catch (e) {
      // If there's an error loading the theme, keep the default light theme
      state = false;
    }
  }

  Future<void> toggleTheme() async {
    try {
      _box ??= await Hive.openBox(_boxName);
      state = !state;
      await _box?.put(_isDarkModeKey, state);
    } catch (e) {
      // If there's an error saving the theme, revert the state change
      state = !state;
    }
  }

  @override
  void dispose() {
    _box?.close();
    super.dispose();
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});
