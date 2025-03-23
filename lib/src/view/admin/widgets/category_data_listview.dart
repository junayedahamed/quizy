import 'package:flutter/material.dart';
import 'package:quizy/src/theme/theme.dart';

class CategoryDataListview extends StatelessWidget {
  const CategoryDataListview({super.key, required this.data});
  final List data;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final category = data[index];
        final totalQuizzes = data.fold(
          0,
          (initialValue, combine) => initialValue + (combine['count'] as int),
        );
        final percentange =
            totalQuizzes > 0
                ? (category['count'] as int) / totalQuizzes * 100
                : 0;

        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['name'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "${category['name']} ${(category['count'] as int) == 1 ? "Quiz" : "Quizzes"} ",
                      style: TextStyle(
                        fontSize: 14,

                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withAlpha(100),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${percentange.toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryColor,
                        ),
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
