import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizy/src/model/category.dart';
import 'package:quizy/src/theme/theme.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key, this.category});
  final Category? category;
  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController _nameConroller = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _nameConroller = TextEditingController(text: widget.category!.name);
    _descriptionController = TextEditingController(
      text: widget.category!.description,
    );
  }

  @override
  void dispose() {
    _nameConroller.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      if (widget.category != null) {
        final updatedCategory =
            widget.category!
                .copyWith(
                  name: _nameConroller.text.trim(),
                  description: _descriptionController.text.trim(),
                )
                .toMap();
        await _firebaseFirestore
            .collection('categories')
            .doc(widget.category!.id)
            .update(updatedCategory);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Category Updated Successfully")),
          );
        }
      } else {
        await _firebaseFirestore
            .collection('categories')
            .add(
              Category(
                id: _firebaseFirestore.databaseId,
                name: _nameConroller.text.trim(),
                description: _descriptionController.text.trim(),
                createdAt: DateTime.now(),
              ).toMap(),
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Category Added Successfully")),
          );
        }
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(backgroundColor: AppTheme.backGroundColor));
  }
}
