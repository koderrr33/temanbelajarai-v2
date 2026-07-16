import 'question.dart';

class ErrorEntry {
  final int questionId;
  final String questionText;
  final List<QuestionOption> options;
  final String correctAnswer;
  final String explanation;
  final String yourAnswer;
  final String attemptedAt;

  ErrorEntry({
    required this.questionId,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.yourAnswer,
    required this.attemptedAt,
  });

  factory ErrorEntry.fromJson(Map<String, dynamic> json) {
    final optionsList = (json['options'] as List<dynamic>?)
            ?.map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return ErrorEntry(
      questionId: json['question_id'] as int? ?? 0,
      questionText: json['question_text'] as String? ?? '',
      options: optionsList,
      correctAnswer: json['correct_answer'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      yourAnswer: json['your_answer'] as String? ?? '',
      attemptedAt: json['attempted_at'] as String? ?? '',
    );
  }
}
