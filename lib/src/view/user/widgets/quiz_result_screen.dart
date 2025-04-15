import 'package:flutter/material.dart';
import 'package:quizy/src/model/quiz.dart';
import 'package:quizy/src/view/user/home_screen.dart';

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
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 250),
              Center(child: Text("$totalQuestion/$correctAnswer")),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text("Go Back", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
