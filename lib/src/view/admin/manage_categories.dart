import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizy/src/model/category.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/admin/add_category_screen.dart';
import 'package:quizy/src/view/admin/manage_qizzes.dart';
import 'package:quizy/src/view/admin/widgets/categories_popup_menu.dart';
import 'package:quizy/src/view/loading_skeleton/listtile_skeleton.dart';

class ManageCategories extends StatefulWidget {
  const ManageCategories({super.key});

  @override
  State<ManageCategories> createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageCategories> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> _handleCategoryAction(
    BuildContext context,
    String action,
    Category categoty,
  ) async {
    if (action == 'edit') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManageQizzes(categoryId: categoty.id),
        ),
      );
    } else if (action == 'delete') {
      // await _firebaseFirestore
      //     .collection('categories')
      //     .doc(categoty.id)
      //     .delete();
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete Category"),
            content: Text("Are you sure you want to delete this category?"),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text("Confrim"),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        await _firebaseFirestore
            .collection('categories')
            .doc(categoty.id)
            .delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Categories",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryScreen()),
              );
            },
            icon: Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _firebaseFirestore
                .collection('categories')
                .orderBy('name')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error occured ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) {
                return ListtileSkeleton();
              },
            );
          }
          // if (snapshot.data!.docs.isEmpty) {
          //   return Center(child: Text("No Categories found"));
          // }
          final categories =
              snapshot.data!.docs
                  .map(
                    (e) => Category.fromMap(
                      e.id,
                      e.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList();
          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15),
                  Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: AppTheme.textSecondaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Categories Not Found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCategoryScreen(),
                        ),
                      );
                    },
                    child: Text("Add Category"),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final Category eachcategory = categories[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),

                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withAlpha(100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.category_outlined,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  title: Text(eachcategory.name),
                  subtitle: Text(eachcategory.description),
                  trailing: CategoriesPopupMenu(
                    onSelected: (value) {
                      _handleCategoryAction(context, value, eachcategory);
                    },
                  ),
                  onTap: () {
                    // Navigator.pop(context, eachcategory);
                    // QuizListScreen
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
