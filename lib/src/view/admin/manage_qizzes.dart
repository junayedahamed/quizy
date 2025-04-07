import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizy/src/model/category.dart';
import 'package:quizy/src/model/quiz.dart';
import 'package:quizy/src/theme/theme.dart';

class ManageQizzes extends StatefulWidget {
  final String? categoryId;
  const ManageQizzes({super.key, this.categoryId});

  @override
  State<ManageQizzes> createState() => _ManageQizzesState();
}

class _ManageQizzesState extends State<ManageQizzes> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _seacrchQuery = '';
  String? _selectedCategoryId;
  List<Category> _category = [];
  Category? _initialCategory;
  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future _fetchCategories() async {
    try {
      final querySnapShot = await _firestore.collection('categories').get();
      final categories =
          querySnapShot.docs
              .map((doc) => Category.fromMap(doc.id, doc.data()))
              .toList();

      setState(() {
        _category = categories;
        if (widget.categoryId != null) {
          _initialCategory = _category.firstWhere(
            (category) => category.id == widget.categoryId,
            orElse:
                () => Category(
                  id: widget.categoryId!,
                  name: "Unknown",
                  description: '',
                ),
          );
          _selectedCategoryId = _initialCategory!.id;
        }
      });
    } catch (e) {
      log("errror when fetch data $e");
    }
  }

  Stream<QuerySnapshot> _getQuizStream() {
    Query query = _firestore.collection('quizzes');
    String? filterCategoryId = _selectedCategoryId ?? widget.categoryId;
    if (filterCategoryId != null) {
      query = query.where('categoryId', isEqualTo: filterCategoryId);
    }
    if (_seacrchQuery.isNotEmpty) {
      query = query.where('name', isGreaterThanOrEqualTo: _seacrchQuery);
    }
    return query.snapshots();
  }

  Widget _buildTile() {
    String? categoryId = _selectedCategoryId ?? widget.categoryId;

    if (categoryId == null) {
      return Text("All Quizzes", style: TextStyle(fontWeight: FontWeight.bold));
    }
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('categories').doc().snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text("Loading");
        }

        final category = Category.fromMap(
          categoryId,
          snapshot.data!.data() as Map<String, dynamic>,
        );

        return Text(
          category.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Quiz",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.search),
                fillColor: Colors.white,
                hintText: "Search Quizezs",
              ),

              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _seacrchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 18,
                ),
                hintText: 'Category',
              ),
              value: _selectedCategoryId,
              items: [
                DropdownMenuItem(value: null, child: Text('All Categories')),

                if (_initialCategory != null &&
                    _category.every((c) => c.id != _initialCategory!.id))
                  DropdownMenuItem(
                    value: _initialCategory!.id,
                    child: Text(_initialCategory!.name),
                  ),
                ..._category.map((e) {
                  return DropdownMenuItem(value: e.id, child: Text(e.name));
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getQuizStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Erroe ${snapshot.error}"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  );
                }
                final qizzes =
                    snapshot.data!.docs
                        .map(
                          (doc) => Quiz.fromMap(
                            doc.id,
                            doc.data() as Map<String, dynamic>,
                          ),
                        )
                        .where(
                          (quiz) =>
                              _seacrchQuery.isEmpty ||
                              quiz.title.toLowerCase().contains(_seacrchQuery),
                        )
                        .toList();
                if (qizzes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 64,
                          color: AppTheme.textSecondaryColor,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Quiz not found",
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Add Quiz"),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemBuilder: (context, index) {
                    final Quiz quiz = qizzes[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withAlpha(100),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.quiz_rounded,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          quiz.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        //TODO
                        // subtitle:  Text(quiz.),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  },
                  padding: EdgeInsets.all(16),
                  itemCount: qizzes.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
