import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) {
    _loadTheme();
  }

  static const _boxName = 'app_settings';
  static const _isDarkModeKey = 'is_dark_mode';

  Future<void> _loadTheme() async {
    final box = await Hive.openBox(_boxName);
    state = box.get(_isDarkModeKey, defaultValue: false);
  }

  Future<void> toggleTheme() async {
    final box = await Hive.openBox(_boxName);
    state = !state;
    await box.put(_isDarkModeKey, state);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});
