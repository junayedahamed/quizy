import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizy/src/model/category.dart';
import 'package:quizy/src/model/quiz.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/user/widgets/quiz_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategotyScreen extends StatefulWidget {
  final Category category;
  const CategotyScreen({super.key, required this.category});

  @override
  State<CategotyScreen> createState() => _CategotyScreenState();
}

class _CategotyScreenState extends State<CategotyScreen> {
  List<Quiz> _quizzes = [];
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isloading = false;
  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    try {
      final snapshot =
          await _firebaseFirestore
              .collection('quizzes')
              .where('categoryId', isEqualTo: widget.category.id)
              .get();
      setState(() {
        _quizzes =
            snapshot.docs
                .map((doc) => Quiz.fromMap(doc.id, doc.data()))
                .toList();
        _isloading = false;
      });
    } catch (e) {
      setState(() {
        _isloading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load Quiz")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Skeletonizer(
        enabled: _isloading,
        effect: ShimmerEffect(),
        child:
            _quizzes.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_rounded,
                        size: 64,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "No Quizzes Avilable",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Go Back"),
                      ),
                    ],
                  ),
                )
                : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      foregroundColor: Colors.white,
                      backgroundColor: AppTheme.primaryColor,
                      expandedHeight: 230,
                      pinned: true,
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),

                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.category.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),

                        background: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category_rounded,
                              size: 64,
                              color: Colors.white,
                            ),
                            SizedBox(height: 16),
                            Text(
                              widget.category.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _quizzes.length,
                          itemBuilder: (context, index) {
                            final quiz = _quizzes[index];
                            return QuizCard(quiz: quiz, index: index);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
