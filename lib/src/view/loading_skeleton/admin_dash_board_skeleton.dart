import 'package:flutter/material.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/admin/widgets/category_stats_design.dart';
import 'package:quizy/src/view/admin/widgets/quiz_action_card.dart';
import 'package:quizy/src/view/admin/widgets/stat_cards.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdminDashBoardSkeleton extends StatelessWidget {
  const AdminDashBoardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Skeletonizer(
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            height: 20,
            width: 240,
            color: AppTheme.skeletonColor,
          ),
        ),
        body: Skeletonizer(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to Admin DashBoard",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                SizedBox(height: 8),

                Text(
                  "Here's you quiz apps overview",
                  style: TextStyle(
                    fontSize: 14,

                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: StatCards(
                        title: "Total Categories",
                        value: "stats['totalCategories'].toString()",
                        icon: Icons.category_rounded,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: StatCards(
                        title: "Total Qizzes",
                        value: "stats['totalQuizzes'].toString()",
                        icon: Icons.quiz_rounded,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ), //category of quiz
                SizedBox(height: 24),
                CategoryStatsDesign(
                  data: [],
                  icon: Icons.pie_chart_outline,
                  title: "Category Statistics",
                ),
                // //quiz recent activity
                SizedBox(height: 24),
                CategoryStatsDesign(
                  icon: Icons.history_outlined,
                  title: "Recent Activity",
                  data: [],
                ),

                //Quiz actions
                QuizActionCard(
                  icon: Icons.speed_rounded,
                  title: "Quiz Actions",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
