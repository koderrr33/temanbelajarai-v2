class QuestionOption {
  final String label;
  final String text;

  QuestionOption({required this.label, required this.text});

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      label: json['label'] as String? ?? '',
      text: json['text'] as String? ?? '',
    );
  }
}

class Question {
  final int id;
  final String questionText;
  final List<QuestionOption> options;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final optionsList = (json['options'] as List<dynamic>?)
            ?.map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return Question(
      id: json['id'] as int,
      questionText: json['question_text'] as String? ?? '',
      options: optionsList,
    );
  }
}

class QuizResult {
  final int total;
  final int correct;
  final int wrong;
  final double score;

  QuizResult({
    required this.total,
    required this.correct,
    required this.wrong,
    required this.score,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      total: json['total'] as int? ?? 0,
      correct: json['correct'] as int? ?? 0,
      wrong: json['wrong'] as int? ?? 0,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SubmitResponse {
  final bool isCorrect;
  final String correctAnswer;
  final String explanation;

  SubmitResponse({
    required this.isCorrect,
    required this.correctAnswer,
    required this.explanation,
  });

  factory SubmitResponse.fromJson(Map<String, dynamic> json) {
    return SubmitResponse(
      isCorrect: json['is_correct'] as bool? ?? false,
      correctAnswer: json['correct_answer'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
    );
  }
}
