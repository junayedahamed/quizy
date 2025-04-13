import 'package:quizy/src/model/question.dart';

class Quiz {
  final String id, title, categoryId;
  int timeLimit;
  final List<Question> question;
  final DateTime? createdAt, updatedAt;
  Quiz({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.question,
    this.createdAt,
    this.updatedAt,
    required this.timeLimit,
  });

  factory Quiz.fromMap(String id, Map<String, dynamic> data) {
    return Quiz(
      id: id,
      title: data['title'],
      categoryId: data['categoryId'],
      question:
          ((data['question'] ?? []) as List)
              .map((e) => Question.fromMap(e))
              .toList()
              .toList(),
      timeLimit: data['timeLimit'],
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap({bool isUpdate = false}) {
    return {
      'title': title,
      'categoryId': categoryId,
      'timeLimit': timeLimit,
      'question': question.map((e) => e.toMap()).toList(),
      if (isUpdate) 'updatedAt': DateTime.now(),
      'createdAt': createdAt,
    };
  }

  Quiz copyWith({
    String? title,
    String? categoryId,
    int? timeLimit,
    List<Question>? question,
    DateTime? createdAt,
  }) {
    return Quiz(
      id: id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      question: question ?? this.question,
      timeLimit: timeLimit ?? this.timeLimit,

      createdAt: createdAt,
    );
  }
}
