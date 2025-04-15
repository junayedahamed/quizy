import 'package:flutter/material.dart';
import 'package:quizy/src/model/quiz.dart';

class QuizResultScreen extends StatelessWidget {
  final Quiz quiz;
  final Map<int, int> selectedAnswer;
  final int correctAnswer;
  final int totalQuestion;

  const QuizResultScreen({
    super.key,
    required this.quiz,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.totalQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("$totalQuestion/$correctAnswer")));
  }
}
