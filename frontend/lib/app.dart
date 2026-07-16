import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/note/upload_note_screen.dart';
import 'screens/quiz/quiz_screen.dart';
import 'screens/quiz/quiz_result_screen.dart';
import 'screens/errors/error_journal_screen.dart';
import 'widgets/starry_background.dart';

class TemanBelajarApp extends StatefulWidget {
  const TemanBelajarApp({super.key});

  @override
  State<TemanBelajarApp> createState() => _TemanBelajarAppState();
}

class _TemanBelajarAppState extends State<TemanBelajarApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final auth = context.watch<AuthProvider>();

    return MaterialApp(
      title: 'Teman Belajar AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      home: auth.isLoggedIn
          ? const DashboardScreen()
          : const LoginScreen(),
      builder: (context, child) {
        return StarryBackground(child: child!);
      },
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/upload-note': (context) => const UploadNoteScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/quiz-result': (context) => const QuizResultScreen(),
        '/error-journal': (context) => const ErrorJournalScreen(),
      },
    );
  }
}
