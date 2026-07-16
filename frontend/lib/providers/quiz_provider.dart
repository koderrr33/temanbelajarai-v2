import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/api_service.dart';

class QuizProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Question> _questions = [];
  int _currentIndex = 0;
  String? _selectedAnswer;
  SubmitResponse? _lastResult;
  QuizResult? _quizResult;
  Map<int, SubmitResponse> _answers = {};
  String? _error;

  bool get isLoading => _isLoading;
  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  Question? get currentQuestion =>
      _currentIndex < _questions.length ? _questions[_currentIndex] : null;
  String? get selectedAnswer => _selectedAnswer;
  SubmitResponse? get lastResult => _lastResult;
  QuizResult? get quizResult => _quizResult;
  int get totalQuestions => _questions.length;
  int get answeredCount => _answers.length;
  String? get error => _error;
  bool get isFinished => _currentIndex >= _questions.length;

  Future<void> loadQuestions(int noteId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _questions = await ApiService.getQuestions(noteId);
      _currentIndex = 0;
      _selectedAnswer = null;
      _lastResult = null;
      _answers = {};
      _quizResult = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectAnswer(String answer) {
    _selectedAnswer = answer;
    notifyListeners();
  }

  Future<SubmitResponse?> submitAnswer() async {
    if (_selectedAnswer == null || currentQuestion == null) return null;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await ApiService.submitAnswer(
        currentQuestion!.id,
        _selectedAnswer!,
      );
      _lastResult = result;
      _answers[currentQuestion!.id] = result;
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void nextQuestion() {
    _currentIndex++;
    _selectedAnswer = null;
    _lastResult = null;
    notifyListeners();
  }

  Future<void> loadResult(int noteId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _quizResult = await ApiService.getQuizResult(noteId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _questions = [];
    _currentIndex = 0;
    _selectedAnswer = null;
    _lastResult = null;
    _quizResult = null;
    _answers = {};
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
