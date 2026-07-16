import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/note_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/error_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ErrorProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const TemanBelajarApp(),
    ),
  );
}
