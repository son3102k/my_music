import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Controls theme switching between 4 predefined variants.
class ThemeNotifier extends ChangeNotifier {
  ThemeVariant _currentVariant;
  ThemeData _themeData;

  ThemeNotifier([ThemeVariant variant = ThemeVariant.spotify])
      : _currentVariant = variant,
        _themeData = createCustomTheme(variant);

  ThemeData get themeData => _themeData;
  ThemeVariant get currentVariant => _currentVariant;

  /// Change to a specific theme variant.
  void setTheme(ThemeVariant variant) {
    _currentVariant = variant;
    _themeData = createCustomTheme(variant);
    notifyListeners();
  }

  /// Get the next theme variant in cycle.
  void nextTheme() {
    final variants = ThemeVariant.values;
    final nextIndex = (variants.indexOf(_currentVariant) + 1) % variants.length;
    setTheme(variants[nextIndex]);
  }
}
