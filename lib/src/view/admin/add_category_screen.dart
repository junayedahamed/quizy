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
    _nameConroller = TextEditingController(text: widget.category?.name ?? "");
    _descriptionController = TextEditingController(
      text: widget.category?.description ?? '',
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

  Future<bool> _onWillPop() async {
    if (_nameConroller.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty) {
      return await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Discard Changes"),
                content: Text("Are you  sure you want to discard changes?"),
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
          ) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.backGroundColor,
          title: Text(
            widget.category != null ? "Edit Category" : "Add Category",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Category Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Add New Category for organizing Quiz",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    controller: _nameConroller,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                      labelText: "Category Name",

                      hintText: "Enter Category name",

                      prefixIcon: Icon(
                        Icons.category_rounded,
                        color: AppTheme.primaryColor,
                      ),
                    ),

                    validator:
                        (value) =>
                            value!.isEmpty ? "Enter Category name" : null,
                    textInputAction: TextInputAction.next,
                  ),

                  SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Category Description",
                      hintText: "Enter Category  Description",
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.description_rounded,
                        color: AppTheme.primaryColor,
                      ),

                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,

                    validator:
                        (value) =>
                            value!.isEmpty ? "Enter  Description name" : null,
                    textInputAction: TextInputAction.next,
                  ),

                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveCategory,
                      child:
                          _isLoading
                              ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                widget.category != null
                                    ? "Update Category"
                                    : "Add Category",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
