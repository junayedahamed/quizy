import 'package:flutter/material.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/admin/widgets/quiz_actions_grid_view.dart';

class QuizActionCard extends StatelessWidget {
  const QuizActionCard({super.key, required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryColor, size: 24),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            QuizActionGridview(),
          ],
        ),
      ),
    );
  }
}
