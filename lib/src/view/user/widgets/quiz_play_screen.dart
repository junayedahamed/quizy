import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quizy/src/model/question.dart';
import 'package:quizy/src/model/quiz.dart';
import 'package:quizy/src/theme/theme.dart';

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
    // _comPleteQuiz();
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
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        color: AppTheme.textPrimaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 55,
                            width: 55,
                            child: CircularProgressIndicator(
                              value:
                                  (_remainingMin * 60 + _remainingSeconds) /
                                  (_totalMiniutes * 60),
                              strokeWidth: 5,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getTimerColor(),
                              ),
                            ),
                          ),
                          Text(
                            '$_remainingMin:${_remainingSeconds.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _getTimerColor(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0,
                      end:
                          (_currentQuestionIndex + 1) /
                          widget.quiz.question.length,
                    ),
                    duration: Duration(milliseconds: 300),
                    builder: (context, progress, child) {
                      return LinearProgressIndicator(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10),
                        ),
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                        minHeight: 6,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.quiz.question.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentQuestionIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final question = widget.quiz.question[index];
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
