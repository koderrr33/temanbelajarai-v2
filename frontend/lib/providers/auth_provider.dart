import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String _userName = '';
  int _userId = 0;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  int get userId => _userId;
  String? get error => _error;

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final name = prefs.getString('user_name') ?? '';
    final id = prefs.getInt('user_id') ?? 0;
    if (token != null && token.isNotEmpty) {
      _isLoggedIn = true;
      _userName = name;
      _userId = id;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String name, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final auth = await ApiService.register(email, name, password);
      _isLoggedIn = true;
      _userName = auth.name;
      _userId = auth.userId;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', auth.name);
      await prefs.setInt('user_id', auth.userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final auth = await ApiService.login(email, password);
      _isLoggedIn = true;
      _userName = auth.name;
      _userId = auth.userId;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', auth.name);
      await prefs.setInt('user_id', auth.userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await ApiService.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_id');
    _isLoggedIn = false;
    _userName = '';
    _userId = 0;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
