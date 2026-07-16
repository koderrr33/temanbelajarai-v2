import 'dart:io';
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/api_service.dart';

class NoteProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Note> _notes = [];
  Note? _selectedNote;
  String? _error;

  bool get isLoading => _isLoading;
  List<Note> get notes => _notes;
  Note? get selectedNote => _selectedNote;
  String? get error => _error;

  Future<void> loadNotes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _notes = await ApiService.getNotes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Note?> uploadNote(String title, File file) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final note = await ApiService.uploadNote(title, file);
      _notes.insert(0, note);
      _isLoading = false;
      notifyListeners();
      return note;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> generateQuestions(int noteId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await ApiService.generateQuestions(noteId);
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

  void selectNote(Note note) {
    _selectedNote = note;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
