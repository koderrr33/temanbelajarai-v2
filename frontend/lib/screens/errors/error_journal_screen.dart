import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/error_provider.dart';
import '../../widgets/empty_state.dart';

class ErrorJournalScreen extends StatefulWidget {
  const ErrorJournalScreen({super.key});

  @override
  State<ErrorJournalScreen> createState() => _ErrorJournalScreenState();
}

class _ErrorJournalScreenState extends State<ErrorJournalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ErrorProvider>().loadErrors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorProvider = context.watch<ErrorProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Jurnal Kesalahan')),
      body: errorProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorProvider.errors.isEmpty
              ? EmptyState(
                  icon: Icons.check_circle_outline,
                  title: 'Belum ada kesalahan',
                  subtitle:
                      'Kamu belum menjawab soal apa pun. Yuk belajar dulu!',
                  actionLabel: 'Mulai Quiz',
                  onAction: () => Navigator.pushNamed(context, '/dashboard'),
                )
              : RefreshIndicator(
                  onRefresh: () => errorProvider.loadErrors(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: errorProvider.errors.length,
                    itemBuilder: (context, index) {
                      final error = errorProvider.errors[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.red, size: 20),
                          ),
                          title: Text(
                            error.questionText,
                            style: theme.textTheme.bodyLarge,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            'Jawabanmu: ${error.yourAnswer} | ${error.attemptedAt}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text(
                                        'Jawaban Benar: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          error.correctAnswer,
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Pembahasan:',
                                    style: theme.textTheme.labelLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    error.explanation,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Pilihan:',
                                    style: theme.textTheme.labelLarge,
                                  ),
                                  ...error.options.map((opt) {
                                    final isCorrect =
                                        opt.label == error.correctAnswer;
                                    final isUserChoice =
                                        opt.label == error.yourAnswer;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${opt.label}. ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isCorrect
                                                  ? Colors.green
                                                  : isUserChoice
                                                      ? Colors.red
                                                      : null,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              opt.text,
                                              style: TextStyle(
                                                color: isCorrect
                                                    ? Colors.green
                                                    : isUserChoice
                                                        ? Colors.red
                                                        : null,
                                              ),
                                            ),
                                          ),
                                          if (isCorrect)
                                            const Icon(Icons.check,
                                                color: Colors.green, size: 18),
                                          if (isUserChoice && !isCorrect)
                                            const Icon(Icons.close,
                                                color: Colors.red, size: 18),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
