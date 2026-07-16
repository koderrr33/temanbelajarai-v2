import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_response.dart';
import '../models/note.dart';
import '../models/question.dart';
import '../models/error_entry.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  static Map<String, String> _headers(String? token) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<AuthResponse> register(
      String email, String name, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: _headers(null),
      body: jsonEncode({
        'email': email,
        'name': name,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final auth = AuthResponse.fromJson(jsonDecode(response.body));
      await saveToken(auth.accessToken);
      return auth;
    }
    throw Exception(jsonDecode(response.body)['detail'] ?? 'Register failed');
  }

  static Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _headers(null),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final auth = AuthResponse.fromJson(jsonDecode(response.body));
      await saveToken(auth.accessToken);
      return auth;
    }
    throw Exception(jsonDecode(response.body)['detail'] ?? 'Login failed');
  }

  static Future<List<Note>> getNotes() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/notes'),
      headers: _headers(token),
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load notes');
  }

  static Future<Note> getNote(int noteId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/notes/$noteId'),
      headers: _headers(token),
    );
    if (response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load note');
  }

  static Future<Note> uploadNote(String title, File file) async {
    final token = await getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/notes/upload'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to upload note');
  }

  static Future<Map<String, dynamic>> generateQuestions(int noteId) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/notes/$noteId/generate'),
      headers: _headers(token),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to generate questions');
  }

  static Future<List<Question>> getQuestions(int noteId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/notes/$noteId/questions'),
      headers: _headers(token),
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load questions');
  }

  static Future<SubmitResponse> submitAnswer(
      int questionId, String selectedAnswer) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/quiz/submit'),
      headers: _headers(token),
      body: jsonEncode({
        'question_id': questionId,
        'selected_answer': selectedAnswer,
      }),
    );
    if (response.statusCode == 200) {
      return SubmitResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to submit answer');
  }

  static Future<QuizResult> getQuizResult(int noteId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/quiz/result/$noteId'),
      headers: _headers(token),
    );
    if (response.statusCode == 200) {
      return QuizResult.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load quiz result');
  }

  static Future<List<ErrorEntry>> getErrors() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/errors'),
      headers: _headers(token),
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list
          .map((e) => ErrorEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load errors');
  }
}
