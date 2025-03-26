import 'package:flutter/material.dart';
import 'package:quizy/src/theme/theme.dart';

class ManageQizzes extends StatefulWidget {
  final String? categoryId;
  const ManageQizzes({super.key, this.categoryId});

  @override
  State<ManageQizzes> createState() => _ManageQizzesState();
}

class _ManageQizzesState extends State<ManageQizzes> {
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
    );
  }
}
