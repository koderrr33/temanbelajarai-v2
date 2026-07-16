import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';

class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({super.key});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int) {
        context.read<QuizProvider>().loadResult(args);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quiz = context.watch<QuizProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Quiz'),
        automaticallyImplyLeading: false,
      ),
      body: quiz.isLoading
          ? const Center(child: CircularProgressIndicator())
          : quiz.quizResult == null
              ? const Center(child: Text('Belum ada hasil'))
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: quiz.quizResult!.score >= 60
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${quiz.quizResult!.score.toInt()}',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: quiz.quizResult!.score >= 60
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Skor kamu',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStat(
                                theme, 'Benar', quiz.quizResult!.correct,
                                Colors.green),
                            _buildStat(
                                theme, 'Salah', quiz.quizResult!.wrong,
                                Colors.red),
                            _buildStat(theme, 'Total', quiz.quizResult!.total,
                                theme.colorScheme.primary),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/dashboard',
                            (route) => false,
                          ),
                          child: const Text('Kembali ke Dashboard'),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/error-journal'),
                          child: const Text('Lihat Jurnal Kesalahan'),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildStat(
      ThemeData theme, String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
