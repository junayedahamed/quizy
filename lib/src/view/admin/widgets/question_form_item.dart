import 'package:flutter/widgets.dart';

class QuestionFormItem {
  final TextEditingController questionController;
  final List<TextEditingController> optionsController;
  int correctOptinIndex;
  QuestionFormItem(
    this.questionController,
    this.optionsController,
    this.correctOptinIndex,
  );
  void dispose() {
    questionController.dispose();
    for (var action in optionsController) {
      action.dispose();
    }
  }
}
