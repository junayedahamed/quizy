import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/admin/widgets/category_stats_design.dart';
import 'package:quizy/src/view/admin/widgets/quiz_action_card.dart';
import 'package:quizy/src/view/admin/widgets/stat_cards.dart';
import 'package:quizy/src/view/loading_skeleton/admin_dash_board_skeleton.dart';
import 'package:quizy/src/view/profile/profile_page.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<Map<String, dynamic>> _fetchStatistics() async {
    final quizCount =
        await _firebaseFirestore.collection('quizzes').count().get();
    //get latest quizes

    final latestQuizez =
        await _firebaseFirestore
            .collection('c')
            .orderBy('createdAt', descending: true)
            .limit(5)
            .get();

    final categoriesCount =
        await _firebaseFirestore.collection('categories').count().get();
    final categories = await _firebaseFirestore.collection('categories').get();
    final categoryData = await Future.wait(
      categories.docs.map((category) async {
        final quizCount =
            await _firebaseFirestore
                .collection('quizzes')
                .where('categoryId', isEqualTo: category.id)
                .count()
                .get();
        return {
          'name': category.data()['name'] as String,
          'count': quizCount.count,
        };
      }),
    );

    return {
      'totalCategories': categoriesCount.count,
      'totalQuizzes': quizCount.count,
      'latestQuizez': latestQuizez.docs,
      'categoryData': categoryData,
    };
  }

  // String _fromDate(DateTime date) {
  //   return '${date.day}/${date.month}/${date.year}';
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      child: Scaffold(
        backgroundColor: AppTheme.backGroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Admin DashBoard",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: Icon(Icons.account_circle, size: 30),
            ),
          ],
        ),
        body: FutureBuilder(
          future: _fetchStatistics(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: AdminDashBoardSkeleton());
            } else if (snapshot.hasData) {
              final Map<String, dynamic> stats = snapshot.data!;
              final List<dynamic> categoryData = stats['categoryData'];
              final List<QueryDocumentSnapshot> latestQuizez =
                  stats['latestQuizez'];
              return SingleChildScrollView(
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
                            value: stats['totalCategories'].toString(),
                            icon: Icons.category_rounded,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: StatCards(
                            title: "Total Qizzes",
                            value: stats['totalQuizzes'].toString(),
                            icon: Icons.quiz_rounded,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ), //category of quiz
                    SizedBox(height: 24),
                    CategoryStatsDesign(
                      data: categoryData,
                      icon: Icons.pie_chart_outline,
                      title: "Category Statistics",
                    ),
                    // //quiz recent activity
                    SizedBox(height: 24),
                    CategoryStatsDesign(
                      icon: Icons.history_outlined,
                      title: "Recent Activity",
                      data: latestQuizez,
                    ),

                    //Quiz actions
                    QuizActionCard(
                      icon: Icons.speed_rounded,
                      title: "Quiz Actions",
                    ),
                  ],
                ),
              );
            }

            return Center(child: Text("Error occured"));
          },
        ),
      ),
    );
  }
}
