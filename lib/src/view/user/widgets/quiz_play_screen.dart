import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quizy/src/model/quiz.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quiz;
  const QuizPlayScreen({super.key, required this.quiz});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  Map<int, int> _selectedanswers = {};
  int _totalMiniutes = 0,
      _remainingMin = 0,
      _remainingSeconds = 0,
      _currentQuestionIndex = 0;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _totalMiniutes = widget.quiz.timeLimit;
    _remainingMin = _totalMiniutes;
    _remainingSeconds = 0;
    _startTimer();
    _comPleteQuiz();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          if (_remainingMin > 0) {
            _remainingMin--;
            _remainingSeconds = 59;
          } else {
            timer.cancel();
          }
        }
      });
    });
  }

  void _selectedans(int optionIndex) {
    if (_selectedanswers[_currentQuestionIndex] == null) {
      setState(() {
        _selectedanswers[_currentQuestionIndex] = optionIndex;
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.question.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.bounceInOut,
      );
    } else {
      _comPleteQuiz();
    }
  }

  void _comPleteQuiz() {
    _timer?.cancel();
    int correctAnswers = _calculateScore();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Quiz Completed")));
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuizResultScreen(quiz:widget.quiz,totalQuestion:widget.quiz.question.length,correctAnswer:correctAnswers,selectedAnswer:_selectedanswers),))
  }

  int _calculateScore() {
    int correctAnswer = 0;
    for (int i = 0; i < widget.quiz.question.length; i++) {
      final selectedAns = _selectedanswers[i];
      if (selectedAns != null &&
          selectedAns == widget.quiz.question[i].correctIndex) {
        correctAnswer++;
      }
    }
    return correctAnswer;
  }

  Color _getTimerColor() {
    double timeProgress =
        1 - ((_remainingMin * 60 + _remainingSeconds) / _totalMiniutes * 60);
    if (timeProgress < 0.4) {
      return Colors.green;
    } else if (timeProgress < 0.6) {
      return Colors.orange;
    } else if (timeProgress < 0.8) {
      return Colors.deepOrangeAccent;
    } else {
      return Colors.redAccent;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
