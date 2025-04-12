import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizy/src/model/question.dart';
import 'package:quizy/src/model/quiz.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/admin/widgets/question_form_item.dart';

class EditQuizScreen extends StatefulWidget {
  final Quiz quiz;
  const EditQuizScreen({super.key, required this.quiz});

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _timeLimitController;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  late List<QuestionFormItem> _questionsItems;
  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeLimitController.dispose();
    for (var action in _questionsItems) {
      action.dispose();
    }

    super.dispose();
  }

  void _initData() {
    _titleController = TextEditingController(text: widget.quiz.title);
    _timeLimitController = TextEditingController(
      text: widget.quiz.timeLimit.toString(),
    );
    _questionsItems =
        widget.quiz.question
            .map(
              (question) => QuestionFormItem(
                TextEditingController(text: question.text),
                question.options
                    .map((option) => TextEditingController(text: option))
                    .toList(),
                question.correctIndex,
              ),
            )
            .toList();
  }

  void _addQuestion() {
    setState(() {
      QuestionFormItem(
        TextEditingController(),
        List.generate(4, (index) {
          return TextEditingController();
        }),
        0,
      );
    });
  }

  void removeQuestion(int index) {
    if (_questionsItems.length > 1) {
      setState(() {
        _questionsItems[index].dispose();
        _questionsItems.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("You must have one question")));
    }
  }

  Future<void> _updateQuiz() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final question =
          _questionsItems
              .map(
                (element) => Question(
                  text: element.questionController.text.trim(),
                  options:
                      element.optionsController.map((option) {
                        return option.text.trim();
                      }).toList(),
                  correctIndex: element.correctOptinIndex,
                ),
              )
              .toList();

      final updateQuiz = widget.quiz.copyWith(
        title: _titleController.text,

        timeLimit: int.tryParse(_timeLimitController.text),
        question: question,
      );

      await _firebaseFirestore
          .collection('quizzes')
          .doc(widget.quiz.id)
          .update(updateQuiz.toMap());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.secondaryColor,
            content: Text(
              "Quiz updated Successfully",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Quiz updated Failed!",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
          snackBarAnimationStyle: AnimationStyle(reverseCurve: Curves.bounceIn),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.backGroundColor,
        title: Text("Edit Quiz", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _updateQuiz,
            icon: Icon(Icons.save, color: AppTheme.primaryColor),
          ),
        ],
      ),
      body: Form(key: _formkey, child: ListView()),
    );
  }
}
