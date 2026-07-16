import 'package:flutter/material.dart';
import '../models/error_entry.dart';
import '../services/api_service.dart';

class ErrorProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<ErrorEntry> _errors = [];
  String? _error;

  bool get isLoading => _isLoading;
  List<ErrorEntry> get errors => _errors;
  String? get error => _error;

  Future<void> loadErrors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _errors = await ApiService.getErrors();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
