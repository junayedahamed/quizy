import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizy/src/model/category.dart';
import 'package:quizy/src/model/question.dart';
import 'package:quizy/src/model/quiz.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/admin/widgets/question_form_item.dart';
// import 'package:skeletonizer/skeletonizer.dart';

class AddQuizScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  const AddQuizScreen({super.key, this.categoryId, this.categoryName});

  @override
  State<AddQuizScreen> createState() => _AddQuizQuestionState();
}

class _AddQuizQuestionState extends State<AddQuizScreen> {
  final _formkey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeLimitController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? _selectCategoryId;
  final List<QuestionFormItem> _questionsItems = [];
  @override
  void initState() {
    super.initState();
    _selectCategoryId = widget.categoryId;
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

  void _addQuestion() {
    setState(() {
      _questionsItems.add(
        QuestionFormItem(
          TextEditingController(),
          List.generate(4, (index) => TextEditingController()),
          0,
        ),
      );
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questionsItems[index].dispose();
      _questionsItems.removeAt(index);
    });
  }

  Future<void> _saveQuiz() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    if (widget.categoryId != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select a Category")));
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

      await _firebaseFirestore
          .collection('quizzes')
          .doc()
          .set(
            Quiz(
              id: _firebaseFirestore.collection('quizzes').doc().id,
              title: _titleController.text,
              categoryId: _selectCategoryId!,
              question: question,
              timeLimit: int.parse(_timeLimitController.text),
              createdAt: DateTime.now(),
            ).toMap(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.secondaryColor,
            content: Text(
              "Quiz Added Successfully",
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
              "Quiz Add Failed!",
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
        title: Text(
          widget.categoryName != null
              ? 'Add ${widget.categoryName} Quiz'
              : "Add Quiz Question",
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _saveQuiz,
            icon: Icon(Icons.save, color: AppTheme.primaryColor),
          ),
        ],
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20),
          children: [
            Column(
              children: [
                Text(
                  "Quiz Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 20),
                    labelText: 'Quiz Title',
                    hintText: 'Enter Quiz Title',
                    prefixIcon: Icon(Icons.title, color: AppTheme.primaryColor),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter quiz title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                if (widget.categoryId == null)
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        _firebaseFirestore
                            .collection('categories')
                            .orderBy('name')
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error Occoured");
                      }
                      if (snapshot.hasData) {
                        final categories =
                            snapshot.data!.docs
                                .map(
                                  (element) => Category.fromMap(
                                    element.id,
                                    element.data() as Map<String, dynamic>,
                                  ),
                                )
                                .toList();

                        return DropdownButtonFormField<String>(
                          validator: (value) {
                            value == null ? 'Please select a category' : null;
                            return null;
                          },
                          value: _selectCategoryId,
                          items:
                              categories
                                  .map(
                                    (element) => DropdownMenuItem(
                                      value: element.id,
                                      child: Text(element.name),
                                    ),
                                  )
                                  .toList(),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                            labelText: 'Category',
                            hintText: 'Select Category',
                            prefixIcon: Icon(
                              Icons.category_rounded,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _selectCategoryId = value;
                            });
                          },
                        );
                      }

                      return SizedBox.shrink();
                    },
                  ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _timeLimitController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 20),
                    labelText: 'Time Limit (In Minitues)',
                    hintText: 'Enter time Limit',
                    prefixIcon: Icon(Icons.timer, color: AppTheme.primaryColor),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter time limit';
                    }
                    final time = int.tryParse(value);
                    if (time == null || time < 0) {
                      return 'Enter valid time limit';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Questions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),

                        ElevatedButton.icon(
                          onPressed: _addQuestion,
                          label: Text('Add Question'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    ..._questionsItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final QuestionFormItem question = entry.value;
                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Question ${index + 1}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimaryColor,
                                    ),
                                  ),
                                  if (_questionsItems.length > 1)
                                    IconButton(
                                      onPressed: () {
                                        _removeQuestion(index);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                ],
                              ),

                              SizedBox(height: 16),
                              TextFormField(
                                controller: question.questionController,
                                decoration: InputDecoration(
                                  labelText: 'Question Title',
                                  hintText: 'Enter Question',
                                  prefixIcon: Icon(
                                    Icons.question_mark,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter valid Question';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 16),
                              ...question.optionsController.asMap().entries.map(
                                (option) {
                                  final optionIndex = option.key;
                                  final controller = option.value;
                                  // return TextFormField(
                                  //   controller: controller,
                                  //   decoration: InputDecoration(
                                  //     labelText: 'Option ${index + 1}',
                                  //     hintText: 'Enter option',
                                  //     prefixIcon: Icon(
                                  //       Icons.check_circle,
                                  //       color: AppTheme.primaryColor,
                                  //     ),
                                  //   ),
                                  //   validator: (value) {
                                  //     if (value == null || value.isEmpty) {
                                  //       return 'Please enter option';
                                  //     }
                                  //     return null;
                                  //   },
                                  // );

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Radio<int>(
                                          activeColor: AppTheme.primaryColor,
                                          value: optionIndex,
                                          groupValue:
                                              question.correctOptinIndex,
                                          onChanged: (value) {
                                            setState(() {
                                              question.correctOptinIndex =
                                                  value!;
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: controller,
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Option ${optionIndex + 1}',
                                              hintText: 'Enter option',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 32),

                    Center(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveQuiz,
                          child:
                              _isLoading
                                  ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    "Save Quiz",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
