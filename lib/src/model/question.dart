class Question {
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
  factory Question.fromMap(Map<String, dynamic> question) {
    return Question(
      text: question['text'] ?? "",
      options: (question['options'] as List?)?.cast() ?? [],
      correctIndex: question['correctIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'text': text, 'options': options, ' correctIndex': correctIndex};
  }

  Question copyWith({String? text, List<String>? options, int? correctIndex}) {
    return Question(
      text: text ?? this.text,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
    );
  }
}
