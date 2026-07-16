import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int) {
        context.read<QuizProvider>().loadQuestions(args);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quiz = context.watch<QuizProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Soal ${quiz.currentIndex + 1}/${quiz.totalQuestions}'),
      ),
      body: quiz.isLoading
          ? const Center(child: CircularProgressIndicator())
          : quiz.questions.isEmpty
              ? const Center(child: Text('Belum ada soal'))
              : _buildQuizContent(context, theme, quiz),
    );
  }

  Widget _buildQuizContent(
      BuildContext context, ThemeData theme, QuizProvider quiz) {
    final question = quiz.currentQuestion;
    if (question == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (quiz.currentIndex + 1) / quiz.totalQuestions,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                question.questionText,
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...question.options.asMap().entries.map((entry) {
            final option = entry.value;
            final isSelected = quiz.selectedAnswer == option.label;
            final hasResult = quiz.lastResult != null;

            Color? optionBg;
            Color? optionText;
            IconData? optionIcon;

            if (hasResult) {
              if (option.label == quiz.lastResult!.correctAnswer) {
                optionBg = Colors.green.withOpacity(0.1);
                optionText = Colors.green;
                optionIcon = Icons.check_circle;
              } else if (isSelected && !quiz.lastResult!.isCorrect) {
                optionBg = Colors.red.withOpacity(0.1);
                optionText = Colors.red;
                optionIcon = Icons.cancel;
              } else {
                optionBg = Colors.transparent;
                optionText = theme.colorScheme.onSurface;
                optionIcon = null;
              }
            } else {
              optionBg = isSelected
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : null;
              optionText = isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface;
              optionIcon = isSelected ? Icons.radio_button_checked : null;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: quiz.lastResult != null
                    ? null
                    : () => quiz.selectAnswer(option.label),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: optionBg,
                    border: Border.all(
                      color: isSelected
                          ? (hasResult && !quiz.lastResult!.isCorrect
                              ? Colors.red
                              : theme.colorScheme.primary)
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          option.label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(option.text,
                            style:
                                TextStyle(fontSize: 15, color: optionText)),
                      ),
                      if (optionIcon != null)
                        Icon(optionIcon, color: optionText),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          if (quiz.lastResult != null) ...[
            Card(
              color: quiz.lastResult!.isCorrect
                  ? Colors.green.withOpacity(0.05)
                  : Colors.red.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          quiz.lastResult!.isCorrect
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: quiz.lastResult!.isCorrect
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          quiz.lastResult!.isCorrect
                              ? 'Benar!'
                              : 'Salah! Jawaban: ${quiz.lastResult!.correctAnswer}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: quiz.lastResult!.isCorrect
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      quiz.lastResult!.explanation,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (quiz.currentIndex + 1 >= quiz.totalQuestions) {
                  Navigator.pushReplacementNamed(context, '/quiz-result',
                      arguments: quiz.questions.isNotEmpty
                          ? ModalRoute.of(context)?.settings.arguments
                          : null);
                } else {
                  quiz.nextQuestion();
                }
              },
              child: Text(
                quiz.currentIndex + 1 >= quiz.totalQuestions
                    ? 'Lihat Hasil'
                    : 'Soal Selanjutnya',
              ),
            ),
          ] else ...[
            ElevatedButton(
              onPressed: quiz.selectedAnswer == null
                  ? null
                  : () async {
                      await quiz.submitAnswer();
                    },
              child: const Text('Jawab'),
            ),
          ],
        ],
      ),
    );
  }
}
