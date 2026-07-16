import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  void toggleTheme(bool dark) {
    _isDark = dark;
    notifyListeners();
  }

  void toggle() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
