import 'package:flutter/material.dart';
import 'package:quizy/src/theme/theme.dart';

class QuizDataListview extends StatelessWidget {
  const QuizDataListview({super.key, required this.data});
  final List data;

  String _fromDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final quiz = data[index].data() as Map<String, dynamic>;

        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withAlpha(100),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.quiz_rounded,
                  size: 20,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Created on ${_fromDate(quiz['createdAt'].toDate())}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
